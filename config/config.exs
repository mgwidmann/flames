# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

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
