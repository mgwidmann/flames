defmodule Flames.Dashboard.ErrorsLive do
  @moduledoc false
  use Flames.Web, :live_view

  @impl true
  def mount(_params, %{"csp_nonces" => csp_nonces}, socket) do
    {:ok,
     socket
     |> assign(csp_nonces: csp_nonces)}
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
    <section id="main" role="main" class="container mx-auto">
      <div class="p-6 mx-auto bg-gradient-to-t from-slate-100 to-slate-300 rounded-xl shadow-lg flex items-center space-x-4">
        123123
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
