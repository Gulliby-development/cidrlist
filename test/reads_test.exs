defmodule Cidrlist.ReadsTest do
  use Cidrlist.RowCase

  rows([
    reads(["check"], true),
    reads(["sort"], true),
    reads(["sort", "--style", "range"], true),
    reads(["merge"], true),
    reads(["count"], true),
    reads(["count", "--mode", "hosts"], true),
    reads(["gaps", "--within", "10.0.0.0/8"], true),
    reads(["gaps", "--within", "10.0.0.0/8", "--style", "mask"], true),
    reads(["contains", "--ip", "1.2.3.4"], true),
    reads(["split", "--prefix", "24"], true),
    reads(["split", "--style", "hex", "--prefix", "8"], true),
    reads([], false),
    reads(["help"], false),
    reads(["-h"], false),
    reads(["--help"], false),
    reads(["--version"], false),
    reads(["frob"], false),
    reads(["check", "--style", "cidr"], false),
    reads(["sort", "--style", "x"], false),
    reads(["gaps"], false),
    reads(["gaps", "--within", "10.0.0.1/8"], false),
    reads(["split", "--prefix", "33"], false),
    reads(["contains", "--ip", "1.2.3"], false),
    reads(["Check"], false)
  ])
end
