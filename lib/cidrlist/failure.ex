defmodule Cidrlist.Failure do
  @moduledoc false

  # An error that carries the exit status of the program: 2 for the command line, 1 for the
  # list and for a command. `new/2` builds one; `Cidrlist.CLI.run/2` turns it into the reply
  # `{status, "", "cidrlist: " <> message <> "\n"}`.
  defexception [:status, :message]

  @type t :: %__MODULE__{status: 1 | 2, message: String.t()}

  @spec new(1 | 2, String.t()) :: t()
  def new(status, message), do: %__MODULE__{status: status, message: message}
end
