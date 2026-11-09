defmodule Cidrlist.Report do
  @moduledoc false

  import Bitwise

  # Text helpers: dotted addresses, block rendering and counts with a noun.
  def dotted(value) do
    [value >>> 24, value >>> 16, value >>> 8, value]
    |> Enum.map_join(".", fn n -> Integer.to_string(n &&& 255) end)
  end

  def render("cidr", first, len), do: dotted(first) <> "/" <> Integer.to_string(len)

  def render("range", first, len) do
    dotted(first) <> "-" <> dotted(Cidrlist.Nets.last(first, len))
  end

  def render(style, first, len), do: Cidrlist.Style.render(first, len, style)

  def plural(1, noun), do: "1 " <> noun
  def plural(count, noun), do: Integer.to_string(count) <> " " <> noun <> "s"
end
