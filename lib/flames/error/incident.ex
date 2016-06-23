defmodule Flames.Error.Incident do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, except: [:__meta__]}

  schema "error_incidents" do
    field :message, :string
    field :timestamp, Ecto.DateTime

    belongs_to :error, Flames.Error

    timestamps
  end

  @required ~w(message timestamp)
  @optional ~w()

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required, @optional)
  end

end
