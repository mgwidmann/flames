defmodule Flames.App do
  use Application

  def start(_type, _args) do
    require Logger
    Logger.debug("Staring up flames for test...")

    children = [
      Task.Supervisor,
      TestRepo,
      Flames.Supervisor
    ]

    opts = [strategy: :one_for_one, name: FlamesTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
