defmodule Flames.Error.Incident do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, except: [:__meta__, :error]}

  embedded_schema do
    field :message, :string
    field :timestamp, Ecto.DateTime

    timestamps()
  end

  @required ~w(message timestamp)a
  @optional ~w()a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end

end
