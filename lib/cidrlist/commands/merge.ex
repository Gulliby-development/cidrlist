defmodule Cidrlist.Commands.Merge do
  @moduledoc false

  # Writes the fewest networks that cover the same addresses as the list.
  def run(options, items) do
    out =
      items
      |> Cidrlist.Merge.blocks()
      |> Enum.map_join(fn {first, len} ->
        Cidrlist.Report.render(options.style, first, len) <> "\n"
      end)

    {:ok, 0, out}
  end
end
