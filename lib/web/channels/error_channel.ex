if Code.ensure_loaded?(Phoenix.Channel) do
  defmodule Flames.ErrorChannel do
    use Flames.Web, :channel

    def join("errors", _params, socket) do
      {:ok, socket}
    end
  end
end
