defmodule CachedRegexs.MixProject do
  use Mix.Project

  def project do
    [
      app: :cached_regexs,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {CachedRegexs.Application, []}
    ]
  end

  defp deps do
    []
  end
end
