defmodule ThemeEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :theme_ex,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      source_url: "https://github.com/pepicrft/theme_ex"
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
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    An Elixir package that implements data structures for the Theme UI theme specification 
    and provides utilities for parsing, validation, and CSS variable generation.
    """
  end

  defp package do
    [
      name: "theme_ex",
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/pepicrft/theme_ex",
        "Theme UI Spec" => "https://theme-ui.com/theme-spec"
      },
      maintainers: ["Pedro Piñera"],
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE)
    ]
  end

  defp docs do
    [
      main: "ThemeEx",
      source_url: "https://github.com/pepicrft/theme_ex"
    ]
  end
end
