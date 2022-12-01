defmodule Flames.Errors do
  import Ecto.Query
  alias Flames.Error.Worker

  def list() do
    repo = Application.get_env(:flames, :repo)

    repo.all(from(e in Flames.Error, order_by: [desc: e.id]))
  end

  def get!(id) do
    repo = Application.get_env(:flames, :repo)

    repo.get!(Flames.Error, id)
  end

  def resolve(id) do
    repo = Application.get_env(:flames, :repo)
    error = get!(id)

    repo.delete!(error)
  end

  def subscribe() do
    endpoint = Application.get_env(:flames, :endpoint)

    endpoint.subscribe(Worker.broadcast_topic())
  end
end
