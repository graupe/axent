defmodule Axent.MixProject do
  use Mix.Project

  def project do
    [
      app: :axent,
      version: "0.999.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      # Docs
      name: "Axent",
      source_url: "https://github.com/graupe/axent",
      homepage_url: "https://github.com/graupe/axent",
      docs: &docs/0
    ]
  end

  defp description do
    """
    Syntactic extensions for Elixir including with-style function definitions,
    typed struct definitions, and short map syntax.
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/graupe/axent"}
    ]
  end

  defp docs do
    [
      # The main page in the docs
      main: "Axent"
      # logo: "path/to/logo.png",
      # extras: ["README.md"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end
end
