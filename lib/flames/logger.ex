defmodule Flames.Logger do
  require Logger
  use GenEvent

  config_message = """
  Please configure the repo Flames should use in your config.exs file.

      config :flames,
        repo: MyApp.Repo,
        endpoint: MyApp.Endpoint \# (Optional, if using Phoenix)
  """
  Application.get_env(:flames, :repo) || raise(config_message)

  def init(_) do
    {:ok, configure()}
  end
  
  defp configure(options \\ []) do
    options = Keyword.merge(options, [])
    flames_config = Keyword.merge(Application.get_env(:logger, :flames, []), options)
    Application.put_env(:logger, :flames, flames_config)
  end

  def handle_event({_level, gl, _event}, state) when node(gl) != node() do
    {:ok, state}
  end

  def handle_event({level, _gl, event}, state) do
    if proceed?(event) && meet_level?(level) do
      Flames.Error.Worker.post_event level, event
    end
    {:ok, state}
  end

  defp proceed?({Logger, _msg, _event_time, meta}) do
    Keyword.get(meta, :flames, true)
  end

  defp meet_level?(lvl) do
    Logger.compare_levels(lvl, :warn) in [:gt, :eq]
  end
end
