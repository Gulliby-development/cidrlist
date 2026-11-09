defmodule Cidrlist.Commands.Contains do
  @moduledoc false

  # Names every network of the list that holds the --ip address, in the order of the input.
  def run(options, items) do
    {:ok, ip} = Cidrlist.Nets.parse_address(options.ip)
    held = Enum.filter(items, fn net -> ip >= net.first and ip <= Cidrlist.Nets.last(net.first, net.len) end)

    case held do
      [] -> {:ok, 1, options.ip <> " is not covered\n"}
      _ -> {:ok, 0, Enum.map_join(held, fn net -> options.ip <> " in " <> Cidrlist.Report.render("cidr", net.first, net.len) <> "\n" end)}
    end
  end
end
