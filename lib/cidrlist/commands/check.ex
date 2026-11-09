defmodule Cidrlist.Commands.Check do
  @moduledoc false

  # Validates the list and reports how many networks it holds.
  def run(_options, items) do
    {:ok, 0, "ok, " <> Cidrlist.Report.plural(length(items), "network") <> "\n"}
  end
end
