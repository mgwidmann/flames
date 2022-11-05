defmodule Dummy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DummyWeb.Telemetry,
      # Start the Ecto repository
      Dummy.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dummy.PubSub},
      # Start Finch
      {Finch, name: Dummy.Finch},
      # Start the Endpoint (http/https)
      DummyWeb.Endpoint
      # Start a worker by calling: Dummy.Worker.start_link(arg)
      # {Dummy.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dummy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DummyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
