defmodule Flames.Error do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, except: [:__meta__]}

  @table Application.get_env(:flames, :table) || "errors"
  schema @table do
    field :message, :string
    field :level, :string
    field :timestamp, :utc_datetime
    field :alive, :boolean
    field :module, :string
    field :function, :string
    field :file, :string
    field :line, :integer
    field :count, :integer
    field :hash, :string

    embeds_many :incidents, Flames.Error.Incident

    timestamps()
  end

  @required ~w(message timestamp alive hash count level)a
  @optional ~w(module function file line)a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end

  def recur_changeset(model, params \\ %{}) do
    model
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> cast_embed(:incidents)
  end

  def find_reported(hash) when is_binary(hash) do
    import Ecto.Query
    from e in __MODULE__,
      where: e.hash == ^hash,
      limit: 1
  end

  def merge(original, dups) do
    counts = original.count + (dups |> Enum.map(&(&1.count)) |> Enum.sum())
    incidents = [original.incidents, Enum.map(dups, &(&1.incidents))]
                |> List.flatten()
                |> Enum.sort_by(&(&1.timestamp))
                |> Enum.reverse()
                |> Enum.map(&Map.from_struct/1)
    changeset(original, %{count: counts, incidents: incidents})
  end

  def reported?(hash) when is_binary(hash) do
    import Ecto.Query
    from e in find_reported(hash), select: true
  end
end
