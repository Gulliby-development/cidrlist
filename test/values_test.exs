defmodule Cidrlist.ValuesTest do
  use Cidrlist.RowCase

  rows([
    row(["sort", "--style", "Cidr"], "", 2, "", "cidrlist: bad value for --style\n"),
    row(["sort", "--style", ""], "", 2, "", "cidrlist: bad value for --style\n"),
    row(["count", "--mode", "all"], "", 2, "", "cidrlist: bad value for --mode\n"),
    row(["split", "--prefix", "33"], "", 2, "", "cidrlist: bad value for --prefix\n"),
    row(["split", "--prefix", "05"], "", 2, "", "cidrlist: bad value for --prefix\n"),
    row(["split", "--prefix", "-1"], "", 2, "", "cidrlist: bad value for --prefix\n"),
    row(["split", "--prefix", "2.5"], "", 2, "", "cidrlist: bad value for --prefix\n"),
    row(["split", "--prefix", ""], "", 2, "", "cidrlist: bad value for --prefix\n"),
    row(["gaps", "--within", "10.0.0.1/24"], "", 2, "", "cidrlist: bad value for --within\n"),
    row(["gaps", "--within", "300.0.0.0/8"], "", 2, "", "cidrlist: bad value for --within\n"),
    row(["gaps", "--within", "10.0.0.0/"], "", 2, "", "cidrlist: bad value for --within\n"),
    row(["gaps", "--within", "10.0.0.0/33"], "", 2, "", "cidrlist: bad value for --within\n"),
    row(["contains", "--ip", "1.2.3"], "", 2, "", "cidrlist: bad value for --ip\n"),
    row(["contains", "--ip", "1.2.3.4/5"], "", 2, "", "cidrlist: bad value for --ip\n"),
    row(["contains", "--ip", "01.2.3.4"], "", 2, "", "cidrlist: bad value for --ip\n"),
    row(["count", "--mode", "addresses"], "10.0.0.0/30\n", 0, "4\n", ""),
    row(["count", "--mode", "hosts"], "10.0.0.0/31\n10.0.0.2/32\n", 0, "3\n", ""),
    row(["split", "--prefix", "31", "--style", "range"], "10.0.0.0/30\n", 0, "10.0.0.0-10.0.0.1\n10.0.0.2-10.0.0.3\n", "")
  ])
end
