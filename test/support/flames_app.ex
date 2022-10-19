defmodule Flames.App do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    require Logger
    Logger.debug("Staring up flames for test...")

    children = [
      supervisor(Task.Supervisor, []),
      supervisor(TestRepo, [])
    ]

    opts = [strategy: :one_for_one, name: FlamesTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
