defmodule Cidrlist.Style do
  @moduledoc false

  # The styles mask and hex of a block (its first address and prefix length).
  def render(first, len, "mask") do
    Cidrlist.Report.dotted(first) <> " " <> Cidrlist.Style.Masks.of(len)
  end

  def render(first, len, "hex") do
    (first |> Integer.to_string(16) |> String.upcase() |> String.pad_leading(8, "0")) <> "/" <> Integer.to_string(len)
  end
end
