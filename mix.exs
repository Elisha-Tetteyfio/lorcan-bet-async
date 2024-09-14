defmodule Lorcan.MixProject do
  use Mix.Project

  def project do
    [
      app: :lorcan,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Lorcan.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.7"},
      {:poison, "~> 5.0"},
      {:httpoison, "~> 2.2"},
      {:ecto, "~> 3.11"},
      {:ecto_sql, "~> 3.11"},
      {:postgrex, "~> 0.18.0"},
      {:dotenv_parser, "~> 2.0"}
    ]
  end
end
