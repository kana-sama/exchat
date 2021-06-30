defmodule ExChat.MixProject do
  use Mix.Project

  def project do
    [
      app: :exchat,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExChat.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.9"},
      {:plug, "~> 1.11"},
      {:plug_cowboy, "~> 2.5"},
      {:poison, "~> 3.1"}
    ]
  end
end
