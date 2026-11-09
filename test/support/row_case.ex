defmodule Cidrlist.RowCase do
  @moduledoc false

  # The test helper of the row files. A row file is a module that uses `Cidrlist.RowCase` and
  # holds one or two lists of literal rows, `rows([...])` and, in the files of part 2,
  # a second one, `totals([...])`:
  #
  #   row(ARGS, STDIN, STATUS, OUT, ERR)  one command line through `Cidrlist.CLI.run/2`
  #   reads(ARGS, EXPECTED)               whether `Cidrlist.CLI.reads_stdin?/1` is true for ARGS
  #
  # Every row of the list is checked, and one failure message names each row that failed.
  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case, async: true
      import Cidrlist.RowCase
    end
  end

  defmacro rows(list) do
    quote do
      test "rows" do
        Cidrlist.RowCase.check_rows(unquote(list))
      end
    end
  end

  defmacro totals(list) do
    quote do
      test "totals" do
        Cidrlist.RowCase.check_rows(unquote(list))
      end
    end
  end

  def row(args, stdin, status, out, err), do: {:row, args, stdin, {status, out, err}}

  def reads(args, expected), do: {:reads, args, expected}

  def check_rows(rows) do
    failures =
      rows
      |> Enum.with_index(1)
      |> Enum.flat_map(fn {row, index} -> check_row(row, index) end)

    if failures != [] do
      ExUnit.Assertions.flunk(Enum.join(failures, "\n"))
    end
  end

  defp check_row({:row, args, stdin, expected}, index) do
    case Cidrlist.CLI.run(args, stdin) do
      ^expected -> []
      got -> ["row #{index} #{inspect(args)}: got #{inspect(got)}, want #{inspect(expected)}"]
    end
  end

  defp check_row({:reads, args, expected}, index) do
    case Cidrlist.CLI.reads_stdin?(args) do
      ^expected -> []
      got -> ["row #{index} #{inspect(args)}: reads_stdin? is #{got}, want #{expected}"]
    end
  end
end
