if Code.ensure_loaded?(Phoenix.Controller) do
  defmodule Flames.ErrorsController do
    @moduledoc false

    use Flames.Web, :controller

    def index(conn, _params) do
      repo = Application.get_env(:flames, :repo)
      errors = repo.all(from e in Flames.Error, order_by: [desc: e.id])
      render(conn, "index.json", errors: errors)
    end

    def interface(conn, _params) do
      render(conn, "index.html")
    end

    def show(conn, %{"id" => error_id}) do
      repo = Application.get_env(:flames, :repo)
      error = repo.one(from e in Flames.Error, where: e.id == ^error_id, limit: 1)
      render(conn, "show.json", error: error)
    end

    def delete(conn, %{"id" => error_id}) do
      repo = Application.get_env(:flames, :repo)
      error = repo.get!(Flames.Error, error_id)

      changeset = Flames.Error.changeset(error, %{ resolved: true })
      repo.update!(changeset)

      send_resp(conn, :no_content, "")
    end

    def search(conn, %{"term" => term}) do
      results = term |> String.split(" ") # TODO: Finish
      conn |> json(%{results: results})
    end
  end
end
