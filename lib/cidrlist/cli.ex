defmodule Cidrlist.CLI do
  @moduledoc false

  alias Cidrlist.{Failure, Input, Nets, Registry}

  @option_keys %{
    "--style" => :style,
    "--mode" => :mode,
    "--within" => :within,
    "--ip" => :ip,
    "--prefix" => :prefix
  }

  # Runs one command line: the command line first, then the list, then the command.
  def run(args, text) do
    case parse(args) do
      {:reply, status, out, err} ->
        {status, out, err}

      {:error, failure} ->
        reply_error(failure)

      {:ok, command, options} ->
        with {:ok, items} <- Input.read_items(text),
             {:ok, status, out} <- command.(options, items) do
          {status, out, ""}
        else
          {:error, %Failure{} = failure} -> reply_error(failure)
        end
    end
  end

  def reads_stdin?(args), do: match?({:ok, _, _}, parse(args))

  defp reply_error(%Failure{status: status, message: message}) do
    {status, "", "cidrlist: " <> message <> "\n"}
  end

  defp usage_error(message), do: {:error, Failure.new(2, message)}

  defp parse([]), do: {:reply, 2, "", Registry.usage()}
  defp parse([word | _]) when word in ["help", "-h", "--help"], do: {:reply, 0, Registry.usage(), ""}
  defp parse(["--version" | _]), do: {:reply, 0, Registry.version() <> "\n", ""}

  defp parse([name | rest]) do
    case Registry.find(name) do
      nil ->
        usage_error("unknown command #{name}")

      {allowed, required, command} ->
        defaults = %{style: "cidr", mode: "addresses", within: "", ip: "", prefix: nil}

        case scan(rest, name, allowed, defaults, []) do
          {:ok, options, seen} ->
            if required == "" or required in seen do
              {:ok, command, options}
            else
              usage_error("missing #{required}")
            end

          {:error, _} = error ->
            error
        end
    end
  end

  defp scan([], _name, _allowed, options, seen), do: {:ok, options, seen}

  defp scan([word | rest], name, allowed, options, seen) do
    cond do
      word == "" or word == "-" or not String.starts_with?(word, "-") ->
        usage_error("unexpected argument #{word}")

      not Map.has_key?(@option_keys, word) ->
        usage_error("unknown option #{word}")

      word not in allowed ->
        usage_error("option #{word} is not valid for #{name}")

      word in seen ->
        usage_error("given twice: #{word}")

      rest == [] ->
        usage_error("missing value for #{word}")

      true ->
        [value | tail] = rest

        case convert(word, value) do
          {:ok, converted} ->
            scan(tail, name, allowed, Map.put(options, @option_keys[word], converted), [word | seen])

          :bad ->
            usage_error("bad value for #{word}")
        end
    end
  end

  defp convert("--style", value), do: if(value in Registry.styles(), do: {:ok, value}, else: :bad)
  defp convert("--mode", value), do: if(value in Registry.modes(), do: {:ok, value}, else: :bad)

  defp convert("--prefix", value) do
    if Regex.match?(~r/\A(0|[1-9][0-9]?)\z/, value) and String.to_integer(value) <= 32 do
      {:ok, String.to_integer(value)}
    else
      :bad
    end
  end

  defp convert("--within", value) do
    case Nets.parse_net(value) do
      {:ok, _, _} -> {:ok, value}
      _ -> :bad
    end
  end

  defp convert("--ip", value) do
    case Nets.parse_address(value) do
      {:ok, _} -> {:ok, value}
      _ -> :bad
    end
  end
end
