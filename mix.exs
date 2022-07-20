defmodule Todo.MixProject do
  use Mix.Project

  @version "1.0.0"
  def project do
    [
      app: :todo_app,
      version: @version,
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {TodoApp, []},
      extra_applications: [
        :logger,
        :ssl,
        :crypto,
        :sasl,
        :tools,
        :inets | extra_applications(Mix.target())
      ]
    ]
  end

  def extra_applications(:host) do
    [:observer]
  end

  def extra_applications(_mobile) do
    []
  end

  defp aliases do
    [
      "assets.deploy": [
        "phx.digest.clean --all",
        "esbuild default --minify",
        "tailwind default --minify",
        "phx.digest"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sqlite3, "~> 0.7"},
      # {:desktop, path: "../desktop"},
      {:desktop, github: "elixir-desktop/desktop", tag: "v1.4.0"},

      # Phoenix
      {:phoenix, "~> 1.6"},
      {:phoenix_live_view, "~> 0.17.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.3", only: [:dev]},
      {:gettext, "~> 0.18"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},

      # Assets
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:petal_components, "~> 0.17"},

      # Credo
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},

      # ml
      {:axon_onnx, github: "elixir-nx/axon_onnx"},
      {:exla, "~> 0.3.0-dev", github: "elixir-nx/nx", sparse: "exla"},
      {:nx, "~> 0.3.0-dev",
       [env: :prod, git: "https://github.com/elixir-nx/nx.git", sparse: "nx", override: true]},
      {:stb_image, "~> 0.4.0"}
    ]
  end
end
