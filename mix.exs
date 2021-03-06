defmodule ConsadoleLive.Mixfile do
  use Mix.Project

  def project do
    [app: :consadole_live,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     escript: escript]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:httpoison, "~> 0.7"},
     {:floki, "~> 0.3"},
     {:oauth, github: "tim/erlang-oauth"},
     {:extwitter, "~> 0.4"}]
  end

  defp escript do
    [main_module: ConsadoleLive.CLI]
  end
end
