defmodule FrontMatter.MixProject do
  use Mix.Project

  def project do
    [
      app: :front_matter,
      version: "1.0.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # Docs
      name: "front_matter",
      source_url: "https://github.com/boostingtech/front_matter",
      docs: [
        main: "FrontMatter",
        extras: ["README.md"]
      ],
      description: description()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "Parse a file or string containing front matter and a document body."
  end

  defp package do
    [
      licenses: ["MIT"],
      name: "front_matter",
      files: ~w(lib .formatter.exs README.md mix.exs LICENSE),
      links: %{"Github" => "https://github.com/boostingtech/front_matter"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:yaml_elixir, "~> 2.5.0"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:git_hooks, "~> 0.5.0", only: [:test, :dev], runtime: false}
    ]
  end
end
