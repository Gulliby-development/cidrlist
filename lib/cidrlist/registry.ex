defmodule Cidrlist.Registry do
  @moduledoc false

  # The version, the limits, the usage text, the styles, the modes and the command table.
  #
  # A network is a map `%{line: non_neg_integer, word: String.t(), first: non_neg_integer,
  # len: 0..32}`: the line number (counted from 1, skipped lines included; 0 for a word that is
  # not on a line), the word as written, the first address as an integer and the prefix length.
  # Options are a map `%{style: String.t(), mode: String.t(), within: String.t(), ip: String.t(),
  # prefix: 0..32 | nil}`: the value of `--style` ("cidr" when absent), of `--mode` ("addresses"
  # when absent), of `--within` and `--ip` ("" when absent) and of `--prefix` (nil when absent).
  # A command is a function `run(options, items)` that returns `{:ok, status, output}` with the
  # exit status and the whole standard output text, or `{:error, %Cidrlist.Failure{}}`.

  @type net :: %{
          line: non_neg_integer,
          word: String.t(),
          first: non_neg_integer,
          len: 0..32
        }
  @type options :: %{
          style: String.t(),
          mode: String.t(),
          within: String.t(),
          ip: String.t(),
          prefix: 0..32 | nil
        }
  @type command_result :: {:ok, 0 | 1, String.t()} | {:error, Cidrlist.Failure.t()}

  def version, do: "cidrlist 0.1.0"
  def max_lines, do: 40
  def max_split, do: 256

  def styles, do: ["cidr", "range", "mask", "hex"]
  def modes, do: ["addresses", "hosts"]

  def usage do
    "usage: cidrlist check\n" <>
      "       cidrlist sort [--style STYLE]\n" <>
      "       cidrlist merge [--style STYLE]\n" <>
      "       cidrlist count [--mode MODE]\n" <>
      "       cidrlist gaps --within NET [--style STYLE]\n" <>
      "       cidrlist contains --ip IP\n" <>
      "       cidrlist split --prefix N [--style STYLE]\n"
  end

  # One entry per command, in the order of the usage text: its word, the options it accepts, the
  # option that must be given (or "") and its function.
  def commands do
    [
      {"check", [], "", &Cidrlist.Commands.Check.run/2},
      {"sort", ["--style"], "", &Cidrlist.Commands.Sort.run/2},
      {"merge", ["--style"], "", &Cidrlist.Commands.Merge.run/2},
      {"count", ["--mode"], "", &Cidrlist.Commands.Count.run/2},
      {"gaps", ["--within", "--style"], "--within", &Cidrlist.Commands.Gaps.run/2},
      {"contains", ["--ip"], "--ip", &Cidrlist.Commands.Contains.run/2},
      {"split", ["--prefix", "--style"], "--prefix", &Cidrlist.Commands.Split.run/2}
    ]
  end

  def find(name) do
    case List.keyfind(commands(), name, 0) do
      {^name, allowed, required, run} -> {allowed, required, run}
      nil -> nil
    end
  end
end
