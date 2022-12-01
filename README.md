# Flames [![hex.pm version](https://img.shields.io/hexpm/v/flames.svg)](https://hex.pm/packages/flames) [![Build Status](https://semaphoreci.com/api/v1/mgwidmann/flames/branches/master/badge.svg)](https://semaphoreci.com/mgwidmann/flames)

![Example Dashboard](example.png)

## Installation

The package can be installed as:

  1. Add `flames` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:flames, "~> 0.7"}]
end
```

  2. Add configuration to tell `flames` what your repository and (optional) Phoenix Endpoint modules are as well as adding it as a Logger backend:

```elixir
config :flames,
  repo: MyPhoenixApp.Repo,
  endpoint: MyPhoenixApp.Endpoint,
  timezone: "America/New_York",
  table: "errors" # Optional, defaults to "errors"

config :logger,
  backends: [:console, Flames.Logger]
```

  3. Add the following migration. Run `mix ecto.gen.migration create_flames_table` to generate a migration file:

```elixir
defmodule MyApp.Repo.Migrations.CreateFlamesTable do
  use Ecto.Migration

  def change do
    # Make sure this table name matches the above configuration
    create table(:errors) do
      add :message, :text
      add :level, :string
      add :timestamp, :utc_datetime
      add :alive, :boolean
      add :module, :string
      add :function, :string
      add :file, :string
      add :line, :integer
      add :count, :integer
      add :hash, :string

      add :incidents, :json

      timestamps()
    end

    create index(:errors, [:hash])
    create index(:errors, [:updated_at])
  end
end
```

Run `mix ecto.migrate` to migrate the database.

  4. Add `import Flames.Router` and `flames "/errors"` to your Phoenix Router for live updates:

  Router (You should place this under a secure pipeline and secure it yourself)
  
```elixir
defmodule MyAppWeb.Router do
  use Phoenix.Router
  import Flames.Router # <--- Add this here

  scope "/admin", MyAppWeb do
    # Define require_admin plug to ensure public users cannot get here
    pipe_through [:browser, :require_admin]

    flames "/errors" # <--- Add this here
  end
end
```


  Visit http://localhost:4000/errors (or wherever you mounted it) to see a live stream of errors.
