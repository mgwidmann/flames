defmodule FakeEndpoint do
  def broadcast(_, _, message) do
    send(self(), {:broadcast, message})
    message
  end
end
