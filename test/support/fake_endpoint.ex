defmodule FakeEndpoint do
  def broadcast(_, _, message) do
    message
  end
end
