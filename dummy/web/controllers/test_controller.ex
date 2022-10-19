defmodule Dummy.TestController do
  use Dummy.Web, :controller

  def index(conn, _) do
    %{non_existent_key: _value} = conn.assigns
  end
end
