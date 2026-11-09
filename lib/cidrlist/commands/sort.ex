defmodule Cidrlist.Commands.Sort do
  @moduledoc false

  # Orders the networks by first address, then prefix length, and renders them.
  def run(options, items) do
    out =
      items
      |> Enum.sort_by(&{&1.first, &1.len})
      |> Enum.map_join(fn item ->
        Cidrlist.Report.render(options.style, item.first, item.len) <> "\n"
      end)

    {:ok, 0, out}
  end
end
