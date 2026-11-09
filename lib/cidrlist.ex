defmodule Cidrlist do
  @moduledoc false

  # The escript entry point. Only this module reads or writes a stream: it reads standard
  # input only when `Cidrlist.CLI.reads_stdin?/1` says the command line is a valid use of a
  # command, and every other reply needs no input.
  def main(args) do
    text = if Cidrlist.CLI.reads_stdin?(args), do: read_stdin(), else: ""
    {status, out, err} = Cidrlist.CLI.run(args, text)
    IO.binwrite(:stdio, out)
    IO.binwrite(:stderr, err)
    System.halt(status)
  end

  defp read_stdin do
    case IO.binread(:stdio, :eof) do
      data when is_binary(data) -> data
      _ -> ""
    end
  end
end
