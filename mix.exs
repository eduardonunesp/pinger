defmodule Pinger.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pinger,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [applications: [
      :logger, :httpotion
    ], mod: {Pinger, []}]
  end

  defp deps do
    [
      {:httpotion, "~> 3.0.0"}
    ]
  end

  defp description do
    """
    Monitoring many URLs as you can and get the realtime
    status for each one
    """
  end

  defp package do
    [
      maintainers: ["Eduardo Nunes Pereira"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/eduardonunesp/pinger"},
      files: ~w(mix.exs README.md lib)
    ]
  end
end
