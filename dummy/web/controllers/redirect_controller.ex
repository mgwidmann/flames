defmodule Dummy.RedirectController do
  use Dummy.Web, :controller

  def index(conn, _) do
    conn
    |> redirect(to: "/errors")
  end
end
