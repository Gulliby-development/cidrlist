defmodule Cidrlist.OptionsTest do
  use Cidrlist.RowCase

  rows([
    row(["sort", "extra"], "", 2, "", "cidrlist: unexpected argument extra\n"),
    row(["sort", "-"], "", 2, "", "cidrlist: unexpected argument -\n"),
    row(["sort", ""], "", 2, "", "cidrlist: unexpected argument \n"),
    row(["sort", "--bogus"], "", 2, "", "cidrlist: unknown option --bogus\n"),
    row(["check", "--style", "cidr"], "", 2, "", "cidrlist: option --style is not valid for check\n"),
    row(["sort", "--mode", "hosts"], "", 2, "", "cidrlist: option --mode is not valid for sort\n"),
    row(["sort", "--style", "cidr", "--style", "cidr"], "", 2, "", "cidrlist: given twice: --style\n"),
    row(["sort", "--style"], "", 2, "", "cidrlist: missing value for --style\n"),
    row(["sort", "-x", "--style"], "", 2, "", "cidrlist: unknown option -x\n"),
    row(["check", "--style"], "", 2, "", "cidrlist: option --style is not valid for check\n"),
    row(["sort", "--style", "x", "--bogus"], "", 2, "", "cidrlist: bad value for --style\n"),
    row(["count", "--style", "hex"], "", 2, "", "cidrlist: option --style is not valid for count\n"),
    row(["merge", "--prefix", "8"], "", 2, "", "cidrlist: option --prefix is not valid for merge\n"),
    row(["gaps"], "", 2, "", "cidrlist: missing --within\n"),
    row(["split"], "", 2, "", "cidrlist: missing --prefix\n"),
    row(["contains"], "", 2, "", "cidrlist: missing --ip\n"),
    row(["gaps", "--style", "mask"], "", 2, "", "cidrlist: missing --within\n"),
    row(["split", "--style", "hex", "--style", "mask"], "", 2, "", "cidrlist: given twice: --style\n"),
    row(["merge", "--style", "range"], "10.0.0.0/25\n10.0.0.128/25\n", 0, "10.0.0.0-10.0.0.255\n", ""),
    row(["count", "--mode", "hosts"], "10.0.0.0/24\n", 0, "254\n", ""),
    row(["sort", "--style", "hex"], "10.0.0.0/8\n", 0, "0A000000/8\n", ""),
    row(["split", "--style", "range", "--prefix", "25"], "10.0.0.0/24\n", 0, "10.0.0.0-10.0.0.127\n10.0.0.128-10.0.0.255\n", ""),
    row(["gaps", "--style", "cidr", "--within", "10.0.0.0/23"], "10.0.0.0/24\n", 0, "10.0.1.0/24\n", ""),
    row(["contains", "--ip", "9.9.9.9"], "9.0.0.0/8\n", 0, "9.9.9.9 in 9.0.0.0/8\n", "")
  ])
end
