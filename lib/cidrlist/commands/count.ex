defmodule Cidrlist.Commands.Count do
  @moduledoc false

  # Counts the addresses the list covers, or the hosts of the merged blocks.
  def run(options, items) do
    total =
      case options.mode do
        "hosts" -> hosts(items)
        _ -> addresses(items)
      end

    {:ok, 0, Integer.to_string(total) <> "\n"}
  end

  defp addresses(items) do
    items
    |> Cidrlist.Merge.intervals()
    |> Enum.reduce(0, fn {first, last}, sum -> sum + last - first + 1 end)
  end

  defp hosts(items) do
    items
    |> Cidrlist.Merge.blocks()
    |> Enum.reduce(0, fn {_first, len}, sum ->
      if len <= 30, do: sum + Cidrlist.Nets.size(len) - 2, else: sum + Cidrlist.Nets.size(len)
    end)
  end
end
