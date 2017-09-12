defmodule Flames do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    require Logger
    Logger.debug "Starting flames!", flames: true
    # Define workers and child supervisors to be supervised
    children = [
      worker(Flames.Error.Worker, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Flames.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
