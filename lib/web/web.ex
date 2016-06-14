defmodule Flames.Web do
  @moduledoc false

  def view do
    quote do
      use Phoenix.View, root: "lib/web/templates"
      use Phoenix.HTML
    end
  end

  def controller do
    quote do
      use Phoenix.Controller
      import Ecto.Query
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  # Serves static files, otherwises passes connection to Flames.Router.
  use Plug.Builder

  plug Plug.Static,
    at: "/", from: :flames,
    only: ~w(css js png)

  plug Flames.Router
end
