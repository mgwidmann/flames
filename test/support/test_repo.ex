defmodule TestRepo do
  use Ecto.Repo, otp_app: :flames, adapter: Ecto.Adapters.Postgres
end
