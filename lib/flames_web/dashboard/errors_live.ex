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
    <header class="d-flex">
      <div id="menu" class="container d-flex flex-column">
        <h1>Flames Dashboard</h1>
        <div id="nav-dropdowns"></div>
      </div>
    </header>
    <section id="main" role="main" class="container"></section>
    """
  end

  # defp live_modal(component, opts) do
  #   path = Keyword.fetch!(opts, :return_to)
  #   title = Keyword.fetch!(opts, :title)
  #   modal_opts = [id: :modal, return_to: path, component: component, opts: opts, title: title]
  #   live_component(Phoenix.LiveDashboard.ModalComponent, modal_opts)
  # end
end
