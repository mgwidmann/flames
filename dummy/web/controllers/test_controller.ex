defmodule Dummy.TestController do
  use Dummy.Web, :controller

  def index(conn, _) do
    raise "Something happened"
  end
end
