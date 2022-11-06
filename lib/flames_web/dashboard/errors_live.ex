defmodule Flames.Dashboard.ErrorsLive do
  @moduledoc false
  use Flames.Web, :live_view
  import Ecto.Query

  @impl true
  def mount(_params, %{"csp_nonces" => csp_nonces}, socket) do
    repo = Application.get_env(:flames, :repo)
    errors = repo.all(from(e in Flames.Error, order_by: [desc: e.id]))

    {:ok,
     socket
     |> assign(errors: errors, csp_nonces: csp_nonces)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <header class="d-flex container mx-auto mx-auto">
      <div id="logo" class="d-flex flex-column">
        <span class="fire">F</span>
        <span class="burn">l</span>
        <span class="burn">a</span>
        <span class="burn">m</span>
        <span class="burn">e</span>
        <span class="fire">s</span>
      </div>
    </header>
    <section id="main" role="main" class="container mx-auto pb-48">
      <div class="mx-2 sm:mx-auto bg-gradient-to-t from-slate-300 to-slate-100 rounded-xl shadow-lg flex items-center space-x-4 pb-6">
        <%!-- <div class="flex flex-col">
          <div class="overflow-x-auto sm:-mx-6 lg:-mx-8"> --%>
            <div class="py-2 inline-block w-full">
              <div class="table w-full">
                <div class="hidden lg:table-header-group">
                  <div class="table-row">
                    <div class="table-cell text-left sticky top-[-10px] bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4">Level</div>
                    <div class="table-cell text-left sticky top-[-10px] bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4">Location</div>
                    <div class="table-cell text-left sticky top-[-10px] bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4">Count</div>
                    <div class="table-cell text-left sticky top-[-10px] bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4">Error</div>
                    <div class="table-cell text-left sticky top-[-10px] bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4"></div>
                  </div>
                </div>
                <div class="table-row-group">
                  <div :for={error <- @errors} class="table-row border-b even:bg-zinc-200 transition duration-300 ease-in-out hover:bg-zinc-300">
                    <div class="lg:table-cell px-3 py-2 text-sm font-medium text-gray-900">
                      <span class="text-xs inline-block py-1 px-2.5 leading-none text-center whitespace-nowrap align-baseline font-bold bg-red-600 text-white rounded uppercase">
                        <%= error.level %>
                      </span>
                    </div>
                    <div class="lg:table-cell text-sm text-gray-900 font-medium px-3 py-2">
                      <%= error.module |> String.to_existing_atom() |> inspect() %>.<%= error.function %>
                    </div>
                    <div class="lg:table-cell text-sm text-gray-900 font-light text-center px-3 py-2">
                      <%= error.count %>
                    </div>
                    <div class="lg:table-cell text-sm text-gray-900 font-light px-3 py-2">
                      <%= error.message |> String.slice(0, 250) |> String.trim_trailing() %>...
                    </div>
                    <div class="lg:table-cell text-sm text-gray-900 font-light px-3 py-2 flex lg:flex-none items-end flex-col w-[90vw] lg:w-auto">
                      <button type="button" class="inline-block px-6 py-2.5 bg-rose-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-rose-700 hover:shadow-lg focus:bg-rose-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-rose-800 active:shadow-lg transition duration-150 ease-in-out">
                        Resolve
                      </button>
                    </div>
                  </div>
                </div>
              </div>



              <%!-- <table class="table-fixed">
                <thead class="border-b">
                  <tr class="">
                    <th scope="col" class="sticky top-0 bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4 text-left">Level</th>
                    <th scope="col" class="sticky top-0 bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4 text-left">Error</th>
                    <th scope="col" class="sticky top-0 bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4 text-left">Location</th>
                    <th scope="col" class="sticky top-0 bg-slate-100 text-sm font-medium text-gray-900 px-6 py-4 text-left"></th>
                  </tr>
                </thead>
                <tbody class="overflow-y-scroll">
                  <tr :for={error <- @errors} class="border-b even:bg-zinc-200 transition duration-300 ease-in-out hover:bg-zinc-300">
                    <td class="w-[50px] px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      <span class="text-xs inline-block py-1 px-2.5 leading-none text-center whitespace-nowrap align-baseline font-bold bg-red-600 text-white rounded uppercase">
                        <%= error.level %>
                      </span>
                    </td>
                    <td class="overflow-y-hidden max-h-[100px] w-[175px] sm:w-[250px] md:w-[400px] lg:w-[575px] xl:w-[735px] 2xl:w-[900px] inline-block text-sm text-gray-900 font-light sm:px-6 sm:py-4"><%= inspect error %></td>
                    <td class="w-[100px] text-sm text-gray-900 font-light px-6 py-4">
                      <%= error.module |> String.to_existing_atom() |> inspect() %>.<%= error.function %>asdfasdfasdfasdf
                    </td>
                    <td class="w-[100px] text-sm text-gray-900 font-light px-6 py-4 whitespace-nowrap">
                      <div class="flex space-x-2 justify-center">
                        <button type="button" class="inline-block px-6 py-2.5 bg-rose-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-rose-700 hover:shadow-lg focus:bg-rose-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-rose-800 active:shadow-lg transition duration-150 ease-in-out">
                          Resolve
                        </button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>--%>
            </div>
          <%!-- </div>
        </div> --%>
      </div>
    </section>
    """
  end

  # defp live_modal(component, opts) do
  #   path = Keyword.fetch!(opts, :return_to)
  #   title = Keyword.fetch!(opts, :title)
  #   modal_opts = [id: :modal, return_to: path, component: component, opts: opts, title: title]
  #   live_component(Phoenix.LiveDashboard.ModalComponent, modal_opts)
  # end
end
