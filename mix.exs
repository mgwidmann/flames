defmodule Flames.Mixfile do
  use Mix.Project

  @version "0.7.2"
  def project do
    [
      app: :flames,
      version: @version,
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: compilers(Mix.env()),
      name: "flames",
      description: description(),
      package: package(),
      source_url: "https://github.com/mgwidmann/flames",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: apps(Mix.env()),
      mod: mod(Mix.env())
    ]
  end

  defp mod(:test), do: {Flames.App, []}
  defp mod(_env), do: []

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp apps(:test), do: apps(nil) ++ [:postgrex]
  defp apps(_), do: [:logger]

  # Need phoenix compiler to compile our views.
  defp compilers(_) do
    compilers()
  end

  defp compilers do
    Mix.compilers()
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.4"},
      {:jason, "~> 1.4"},
      {:phoenix, "~> 1.6"},
      {:phoenix_live_view, "~> 0.18"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.1"},
      {:postgrex, "~> 0.15", only: :test},
      {:ex_doc, "~> 0.22", only: [:docs, :dev]},
      {:earmark, "~> 1.4", only: [:docs, :dev]},
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1.8", runtime: Mix.env() == :dev},
      {:heroicons, "~> 0.5"}
    ]
  end

  defp description do
    """
    Live error monitoring to watch your Phoenix app going up in flames in real time!

    Open source version of error aggregation services. Hooks into Elixir's Logger to provide accurate error
    reporting all throughout your application.
    """
  end

  defp package do
    [
      maintainers: ["Matt Widmann"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "http://github.com/mgwidmann/flames",
        "Docs" => "http://hexdocs.pm/flames/"
      }
    ]
  end

  defp aliases do
    [
      publish: ["assets.deploy", "hex.publish", "hex.publish docs", "tag"],
      "build.assets": &npm_build/1,
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify"],
      tag: &tag_release/1
    ]
  end

  defp tag_release(_) do
    Mix.shell().info("Tagging release as #{@version}")
    System.cmd("git", ["tag", "-a", "v#{@version}", "-m", "v#{@version}"])
    System.cmd("git", ["push", "--tags"])
  end

  defp npm_build(_) do
    Mix.shell().info([IO.ANSI.cyan(), "Building assets...", IO.ANSI.default_color()])
    System.cmd("npm", ["run", "build"])
  end
end
