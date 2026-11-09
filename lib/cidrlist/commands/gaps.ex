defmodule Cidrlist.Commands.Gaps do
  @moduledoc false

  # Writes the addresses of --within that no network of the list covers, as the fewest blocks.
  def run(options, items) do
    {:ok, wfirst, wlen} = Cidrlist.Nets.parse_net(options.within)
    wlast = Cidrlist.Nets.last(wfirst, wlen)

    clipped =
      items
      |> Cidrlist.Merge.intervals()
      |> Enum.filter(fn {first, last} -> last >= wfirst and first <= wlast end)
      |> Enum.map(fn {first, last} -> {max(first, wfirst), min(last, wlast)} end)

    blocks =
      clipped
      |> uncovered(wfirst, wlast)
      |> Enum.flat_map(fn {gfirst, glast} -> Cidrlist.Merge.decompose(gfirst, glast) end)

    case blocks do
      [] ->
        {:ok, 0, "none\n"}

      _ ->
        out =
          Enum.map_join(blocks, fn {first, len} ->
            Cidrlist.Report.render(options.style, first, len) <> "\n"
          end)

        {:ok, 0, out}
    end
  end

  defp uncovered(intervals, wfirst, wlast) do
    {gaps, cursor} =
      Enum.reduce(intervals, {[], wfirst}, fn {first, last}, {acc, cursor} ->
        acc = if cursor < first, do: [{cursor, first - 1} | acc], else: acc
        {acc, last + 1}
      end)

    gaps = if cursor <= wlast, do: [{cursor, wlast} | gaps], else: gaps
    Enum.reverse(gaps)
  end
end
