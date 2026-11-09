defmodule Cidrlist.Merge do
  @moduledoc false

  # The union of networks as sorted disjoint intervals and as the fewest blocks.
  def intervals(items) do
    items
    |> Enum.map(fn item -> {item.first, Cidrlist.Nets.last(item.first, item.len)} end)
    |> Enum.sort()
    |> Enum.reduce([], &join/2)
    |> Enum.reverse()
  end

  def decompose(first, last), do: decompose(first, last, [])

  def blocks(items) do
    items
    |> intervals()
    |> Enum.flat_map(fn {first, last} -> decompose(first, last) end)
  end

  defp join({first, last}, [{pfirst, plast} | rest]) when first <= plast + 1 do
    [{pfirst, max(plast, last)} | rest]
  end

  defp join(interval, acc), do: [interval | acc]

  defp decompose(start, last, acc) when start > last, do: Enum.reverse(acc)

  defp decompose(start, last, acc) do
    len =
      Enum.find(0..32, fn len ->
        size = Cidrlist.Nets.size(len)
        rem(start, size) == 0 and start + size - 1 <= last
      end)

    decompose(start + Cidrlist.Nets.size(len), last, [{start, len} | acc])
  end
end
