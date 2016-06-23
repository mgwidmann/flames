if Code.ensure_loaded?(Phoenix.Controller) do
  defmodule Flames.ErrorsController do
    @moduledoc false

    use Flames.Web, :controller

    @repo Application.get_env(:flames, :repo)
    @endpoint Application.get_env(:flames, :endpoint)
    def index(conn, _params) do
      errors = @repo.all(from e in Flames.Error, order_by: [desc: e.id], preload: [:incidents])
      token = Phoenix.Token.sign(@endpoint, "flames", "flames") # Sign the word "flames" with key "flames"
      render(conn, "index.json", errors: errors)
    end

    def interface(conn, _params) do
      render(conn, "index.html")
    end

    def show(conn, %{"id" => error_id}) do
      error = @repo.one(from e in Flames.Error, where: e.id == ^error_id, preload: [:incidents], limit: 1)
      render(conn, "show.json", error: error)
    end

    def delete(conn, %{"id" => error_id}) do
      error = @repo.get!(Flames.Error, error_id)
      @repo.delete!(error)

      send_resp(conn, :no_content, "")
    end

    def search(conn, %{"term" => term}) do
      term |> String.split(" ")
    end
  end
end
