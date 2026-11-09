defmodule Cidrlist.InputTest do
  use Cidrlist.RowCase

  rows([
    row(["check"], "", 1, "", "cidrlist: no networks\n"),
    row(["check"], "\n", 1, "", "cidrlist: no networks\n"),
    row(["check"], "# only\n\n   \n", 1, "", "cidrlist: no networks\n"),
    row(["check"], "10.0.0.0/8", 0, "ok, 1 network\n", ""),
    row(["check"], "10.0.0.0/8\n11.0.0.0/8", 0, "ok, 2 networks\n", ""),
    row(["check"], "10.0.0.0/8\r\n11.0.0.0/8\r\n", 0, "ok, 2 networks\n", ""),
    row(["check"], "10.0.0.0/8\n10.0.0.0/8 11.0.0.0/8\n", 1, "", "cidrlist: line 2: expected 1 network\n"),
    row(["check"], "\n# c\n10.0.0.0/8\n10.0.0.0 /8\n", 1, "", "cidrlist: line 4: expected 1 network\n"),
    row(["check"], "  10.0.0.0/8  \n\t11.0.0.0/8\t\n", 0, "ok, 2 networks\n", ""),
    row(["check"], "10.0.0.0/8\n   # note\n11.0.0.0/8\n#12.0.0.0/8\n", 0, "ok, 2 networks\n", ""),
    row(["check"], "10.0.0.0/8\nfrob\n11.0.0.0/8\nbad\n", 1, "", "cidrlist: line 2: bad network frob\n"),
    row(["check"], "10.0.0.0/8\nx\n1 2\n", 1, "", "cidrlist: line 2: bad network x\n"),
    row(["check"], "10.0.0.0/8\n10.0.0.0/8 #c\n", 1, "", "cidrlist: line 2: expected 1 network\n"),
    row(["check"], "10.0.0.0/8\n\n\n1.2.3\n", 1, "", "cidrlist: line 4: bad network 1.2.3\n"),
    row(["sort"], "10.0.0.0/8\n\t\n", 0, "10.0.0.0/8\n", "")
  ])
end
