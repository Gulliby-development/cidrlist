defmodule Cidrlist.Commands.Split do
  @moduledoc false

  # Cuts every network of the list into blocks of prefix length --prefix.
  def run(options, items) do
    prefix = options.prefix

    case Enum.find(items, fn item -> item.len > prefix end) do
      nil -> split(options, items)
      item -> {:error, Cidrlist.Failure.new(1, "line #{item.line}: cannot split #{item.word} into /#{prefix}")}
    end
  end

  defp split(options, items) do
    prefix = options.prefix
    total = items |> Enum.map(fn item -> Integer.pow(2, prefix - item.len) end) |> Enum.sum()

    if total > Cidrlist.Registry.max_split() do
      {:error, Cidrlist.Failure.new(1, "too many subnets (max #{Cidrlist.Registry.max_split()})")}
    else
      step = Cidrlist.Nets.size(prefix)

      out =
        Enum.map_join(items, fn item ->
          Enum.map_join(0..(Integer.pow(2, prefix - item.len) - 1), fn i ->
            Cidrlist.Report.render(options.style, item.first + i * step, prefix) <> "\n"
          end)
        end)

      {:ok, 0, out}
    end
  end
end
