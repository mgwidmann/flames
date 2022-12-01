defmodule Flames.Dashboard.ShowErrorLive do
  @moduledoc false
  use Flames.Web, :live_view
  alias Flames.Errors

  @impl true
  def mount(_params, %{"csp_nonces" => csp_nonces}, socket) do
    {:ok,
     socket
     |> assign(csp_nonces: csp_nonces)}
  end

  @impl true
  def handle_params(%{"error" => id}, url, socket) do
    uri = URI.parse(url)
    # Drop /123
    path = Path.dirname(uri.path)
    error = Errors.get!(id)

    {
      :noreply,
      socket
      |> assign(:basepath, path)
      |> assign(:error, error)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full">
      <header class="flex items-center justify-between gap-6">
        <div class="mt-2">
          <.link
            navigate={@basepath}
            class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
          >
            <Heroicons.arrow_left solid class="w-3 h-3 stroke-current inline" /> Back
          </.link>
        </div>
        <div class="flex-none">
          <.button phx-click={JS.push("resolve")} phx-value-id={@error.id}>Resolve</.button>
        </div>
      </header>
      <.level level={@error.level} />
      <div class="py-2 inline-block w-full">
        <div class="grid grid-cols-4 md:grid-cols-8 gap-4">
          <div>
            First Occurence:
          </div>
          <div class="col-span-3 md:col-span-7">
            <%= display_timestamp(@error.timestamp) %>
          </div>
          <div>
            Last Occurence:
          </div>
          <div class="col-span-3 md:col-span-7">
            <%= last_incident_timestamp(@error) %>
          </div>
          <div>
            Module:
          </div>
          <div class="col-span-3 md:col-span-7">
            <%= display_module(@error.module) %>
          </div>
          <div>
            Function:
          </div>
          <div class="col-span-3 md:col-span-7">
            <%= @error.function %>
          </div>
          <div>
            Location:
          </div>
          <div class="col-span-3 md:col-span-7">
            <%= @error.file %>:<%= @error.line %>
          </div>
        </div>
        <pre class="whitespace-pre-wrap mt-10"><%= @error.message |> display_message() %></pre>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("resolve", %{"id" => id}, socket) do
    Errors.resolve(id)

    {:noreply, push_navigate(socket, to: socket.assigns.basepath)}
  end

  def last_incident_timestamp(%Flames.Error{
        incidents: [%Flames.Error.Incident{timestamp: timestamp} | _]
      }) do
    display_timestamp(timestamp)
  end

  def last_incident_timestamp(%Flames.Error{timestamp: timestamp}) do
    display_timestamp(timestamp)
  end

  def last_incident_timestamp(_error) do
    "(Unknown)"
  end

  def display_message(message) do
    message
    |> String.replace("\\n", "\n", global: true)
  end
end
