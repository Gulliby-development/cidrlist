defmodule Cidrlist.Input do
  @moduledoc false

  alias Cidrlist.{Failure, Nets, Registry}

  # Reads the list: lines, skipped lines, and the networks in input order.
  def read_items(text) do
    lines = split_lines(text)

    if length(lines) > Registry.max_lines() do
      {:error, Failure.new(1, "input is too long (max #{Registry.max_lines()} lines)")}
    else
      lines |> Enum.with_index(1) |> collect([])
    end
  end

  defp split_lines(text) do
    case String.split(text, "\n") do
      parts -> if List.last(parts) == "", do: Enum.drop(parts, -1), else: parts
    end
  end

  defp collect([], []), do: {:error, Failure.new(1, "no networks")}
  defp collect([], acc), do: {:ok, Enum.reverse(acc)}

  defp collect([{line, n} | rest], acc) do
    line = if String.ends_with?(line, "\r"), do: binary_part(line, 0, byte_size(line) - 1), else: line

    case String.split(line, [" ", "\t"], trim: true) do
      [] -> collect(rest, acc)
      ["#" <> _ | _] -> collect(rest, acc)
      [word] -> one(word, n, rest, acc)
      _ -> {:error, Failure.new(1, "line #{n}: expected 1 network")}
    end
  end

  defp one(word, n, rest, acc) do
    case Nets.parse_net(word) do
      {:ok, first, len} -> collect(rest, [%{line: n, word: word, first: first, len: len} | acc])
      :bad -> {:error, Failure.new(1, "line #{n}: bad network #{word}")}
      :host_bits -> {:error, Failure.new(1, "line #{n}: host bits set #{word}")}
    end
  end
end
