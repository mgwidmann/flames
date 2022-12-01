defmodule Flames.Dashboard.ErrorsLive do
  @moduledoc false
  use Flames.Web, :live_view
  alias Flames.Errors

  @impl true
  def mount(_params, %{"csp_nonces" => csp_nonces}, socket) do
    errors = Errors.list()

    {:ok,
     socket
     |> assign(errors: errors, csp_nonces: csp_nonces)}
  end

  @impl true
  def handle_params(_params, url, socket) do
    uri = URI.parse(url)

    {
      :noreply,
      socket
      |> assign(:basepath, uri.path)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="py-2 inline-block w-full">
      <div class="table w-full">
        <div class="hidden lg:table-header-group">
          <div class="table-row">
            <div class="table-cell text-left sticky top-[-10px] bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4">
              Level
            </div>
            <div class="table-cell text-left sticky top-[-10px] bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4">
              Location
            </div>
            <div class="table-cell text-left sticky top-[-10px] bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4">
              Count
            </div>
            <div class="table-cell text-left sticky top-[-10px] bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4">
              Error
            </div>
            <div class="table-cell text-left sticky top-[-10px] bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4">
            </div>
          </div>
        </div>
        <div class="table-row-group">
          <div
            :for={error <- @errors}
            class="table-row border-b even:bg-zinc-200 transition duration-300 ease-in-out hover:bg-zinc-300"
          >
            <div class="lg:table-cell px-3 py-2 text-sm font-medium text-gray-900">
              <.level level={error.level} />
            </div>
            <div
              class="lg:table-cell text-sm text-gray-900 font-medium px-3 py-2 hover:cursor-pointer"
              phx-click={JS.navigate("#{@basepath}/#{error.id}")}
            >
              <%= if error.module != nil do %>
                <span class="italic">
                  <%= error.module |> display_module() %>
                </span>
                <br />
                <%= error.file %>:<%= error.line %>
                <br />
                <%= error.function %>
              <% else %>
                <span class="italic">(No Location Information)</span>
              <% end %>
            </div>
            <div class="lg:table-cell text-sm text-gray-900 font-light text-center px-3 py-2">
              <%= error.count %>
            </div>
            <div class="lg:table-cell text-sm text-gray-900 font-light px-3 py-2">
              <%= error.message |> String.slice(0, 250) |> String.trim_trailing() %>
              <%= if String.length(error.message) > 250 do %>
                ...
              <% end %>
            </div>
            <div class="lg:table-cell text-sm text-gray-900 font-light px-3 py-2 flex lg:flex-none items-end flex-col w-[90vw] lg:w-auto">
              <.button phx-click={JS.push("resolve")} phx-value-id={error.id}>Resolve</.button>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("resolve", %{"id" => id}, socket) do
    Errors.resolve(id)

    {:noreply, assign(socket, errors: Errors.list())}
  end
end
