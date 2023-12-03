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
  def handle_params(%{"error" => id} = params, url, socket) do
    uri = URI.parse(url)
    # Drop /123
    path = Path.dirname(uri.path)
    error = Errors.get!(id)
    {incident, ""} = Integer.parse(params["incident"] || "-1")

    {
      :noreply,
      socket
      |> assign(:basepath, path)
      |> assign(:error, error)
      |> assign(:incident, incident)
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
          <.button
            :if={@incident >= 0}
            color={:amber}
            phx-click={JS.push("prev")}
            phx-value-incident={@incident - 1}
          >
            <Heroicons.chevron_left solid class="w-3 h-3 stroke-current inline" />
          </.button>
          <.button
            :if={@incident < length(@error.incidents) - 1}
            phx-click={JS.push("next")}
            color={:amber}
            phx-value-incident={@incident + 1}
          >
            <Heroicons.chevron_right solid class="w-3 h-3 stroke-current inline" />
          </.button>
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
          <div>
            Count:
          </div>
          <div class="col-span-3 md:col-span-7">
            <%= if(@incident < 0, do: "Original", else: @incident + 1) %> out of <%= length(
              @error.incidents
            ) %>
          </div>
          <div>
            Occurred at:
          </div>
          <div class="col-span-3 md:col-span-7">
            <%= if @incident < 0 do %>
              <%= display_timestamp(@error.timestamp) %>
            <% else %>
              <%= Enum.at(@error.incidents || [], @incident) &&
                display_timestamp(
                  (@error.incidents
                   |> Enum.reverse()
                   |> Enum.at(@incident)).timestamp
                ) %>
            <% end %>
          </div>
        </div>
        <pre class="whitespace-pre-wrap mt-10">
          <%= pick_message(@error, @incident) |> display_message() %>
        </pre>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("resolve", %{"id" => id}, socket) do
    Errors.resolve(id)

    {:noreply, push_navigate(socket, to: socket.assigns.basepath)}
  end

  def handle_event(prev_or_next, %{"incident" => indcident_index_string}, socket)
      when prev_or_next in ["prev", "next"] do
    {incident_index, ""} = Integer.parse(indcident_index_string)

    {
      :noreply,
      socket
      |> assign(:incident, incident_index)
      |> push_patch(
        to: "#{socket.assigns.basepath}/#{socket.assigns.error.id}?incident=#{incident_index}"
      )
    }
  end

  def pick_message(error, 0) do
    error.message
  end

  def pick_message(error, incident_index) do
    incident = Enum.at(error.incidents || [], incident_index)
    (incident || error).message
  end

  def display_message(message) do
    message
    |> String.replace("\\n", "\n", global: true)
  end
end
