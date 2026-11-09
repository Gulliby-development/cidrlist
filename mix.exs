defmodule Cidrlist.MixProject do
  use Mix.Project

  def project do
    [
      app: :cidrlist,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      escript: [main_module: Cidrlist],
      deps: []
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]
end
