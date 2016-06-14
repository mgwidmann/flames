if Code.ensure_loaded?(Phoenix.Controller) do
  defmodule Flames.ErrorsController do
    @moduledoc false

    use Flames.Web, :controller

    @repo Application.get_env(:flames, :repo)
    @endpoint Application.get_env(:flames, :endpoint)
    def index(conn, _params) do
      errors = @repo.all(from e in Flames.Error, order_by: [desc: e.id])
      token = Phoenix.Token.sign(@endpoint, "flames", "flames") # Sign the word "flames" with key "flames"
      render(conn, "index.json", errors: errors)
    end

    def interface(conn, _params) do
      render(conn, "index.html")
    end

    def show(conn, %{"id" => error_id}) do
      error = @repo.get!(Flames.Error, error_id)
      render(conn, "show.json", error: error)
    end
  end
end
