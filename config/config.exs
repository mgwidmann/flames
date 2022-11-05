# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

config :flames,
  repo: TestRepo,
  endpoint: FakeEndpoint

config :flames,
  ecto_repos: [TestRepo]

config :phoenix, :json_library, Jason

# Configure your database
config :flames, TestRepo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || "postgres",
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "postgres",
  database: "flames_test",
  hostname: "localhost",
  pool_size: 10,
  priv: "priv/repo"

config :logger,
  level: :info

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.1.8",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]
