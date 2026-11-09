defmodule Cidrlist.UsageTest do
  use Cidrlist.RowCase

  rows([
    row(["help"], "", 0, "usage: cidrlist check\n       cidrlist sort [--style STYLE]\n       cidrlist merge [--style STYLE]\n       cidrlist count [--mode MODE]\n       cidrlist gaps --within NET [--style STYLE]\n       cidrlist contains --ip IP\n       cidrlist split --prefix N [--style STYLE]\n", ""),
    row(["-h"], "", 0, "usage: cidrlist check\n       cidrlist sort [--style STYLE]\n       cidrlist merge [--style STYLE]\n       cidrlist count [--mode MODE]\n       cidrlist gaps --within NET [--style STYLE]\n       cidrlist contains --ip IP\n       cidrlist split --prefix N [--style STYLE]\n", ""),
    row(["--help", "--bogus"], "", 0, "usage: cidrlist check\n       cidrlist sort [--style STYLE]\n       cidrlist merge [--style STYLE]\n       cidrlist count [--mode MODE]\n       cidrlist gaps --within NET [--style STYLE]\n       cidrlist contains --ip IP\n       cidrlist split --prefix N [--style STYLE]\n", ""),
    row([], "", 2, "", "usage: cidrlist check\n       cidrlist sort [--style STYLE]\n       cidrlist merge [--style STYLE]\n       cidrlist count [--mode MODE]\n       cidrlist gaps --within NET [--style STYLE]\n       cidrlist contains --ip IP\n       cidrlist split --prefix N [--style STYLE]\n"),
    row(["--version"], "", 0, "cidrlist 0.1.0\n", ""),
    row(["--version", "x"], "", 0, "cidrlist 0.1.0\n", ""),
    row(["frob"], "", 2, "", "cidrlist: unknown command frob\n"),
    row([""], "", 2, "", "cidrlist: unknown command \n"),
    row(["Check"], "", 2, "", "cidrlist: unknown command Check\n"),
    row(["-H"], "", 2, "", "cidrlist: unknown command -H\n")
  ])
end
