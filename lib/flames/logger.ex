defmodule Flames.Logger do
  require Logger
  use GenEvent

  config_message = """
  Please configure the repo Flames should use in your config.exs file.

      config :flames,
        repo: MyApp.Repo,
        endpoint: MyApp.Endpoint \# (Optional, if using Phoenix)
  """
  @repo Application.get_env(:flames, :repo) || raise(config_message)
  @endpoint Application.get_env(:flames, :endpoint) || raise(config_message)

  def init(_) do
    {:ok, configure}
  end

  def handle_event({_level, gl, _event}, state) when node(gl) != node() do
    {:ok, state}
  end

  def handle_event({level, _gl, event}, state) do
    if proceed?(event) && meet_level?(level) do
      Task.start(__MODULE__, :post_event, [level, event])
    end
    {:ok, state}
  end

  defp proceed?({Logger, _msg, _event_time, meta}) do
    Keyword.get(meta, :flames, true)
  end

  defp meet_level?(lvl) do
    Logger.compare_levels(lvl, :warn) in [:gt, :eq]
  end

  def post_event(level, data) do
    level
    |> error_changeset(data)
    |> @repo.insert_or_update()
    |> broadcast()
  end

  defp broadcast({:ok, error}) do
    @endpoint.broadcast("errors", "error", error)
  end
  defp broadcast({:error, _}), do: nil

  defp configure(options \\ []) do
    options = Keyword.merge(options, [])
    flames_config = Keyword.merge(Application.get_env(:logger, :flames, []), options)
    Application.put_env(:logger, :flames, flames_config)
  end

  defp error_changeset(level, {Logger, msg, ts, md}) do
    message = normalize_message(msg)
    hash = hash(message.full)
    if e = Flames.Error.find_reported(hash) |> @repo.one() do
      e
      |> @repo.preload([:incidents])
      |> Flames.Error.recur_changeset(%{
        count: e.count + 1,
        incidents: [%{message: message.full, timestamp: ts} | e.incidents]
      })
    else
      Flames.Error.changeset(%Flames.Error{}, %{
        message: msg,
        level: to_string(level),
        timestamp: ts,
        alive: Process.alive?(md[:pid]),
        module: md[:module] && to_string(md[:module]),
        function: message.fun || md[:function],
        file: md[:file] |> file_string(),
        line: md[:line],
        hash: hash,
        count: 1
      })
    end
  end

  defp normalize_message(full_message = [message, stack, fun | args]) do
    %{
      message: IO.chardata_to_string(message),
      stack: IO.chardata_to_string(stack),
      fun: String.strip(fun) |> String.replace("Function: ", ""),
      args: String.strip(args) |> String.replace("Args: "),
      full: IO.chardata_to_string(full_message)
    }
  end
  defp normalize_message(message) do
    %{
      message: message,
      stack: nil,
      fun: nil,
      args: nil,
      full: message
    }
  end

  @cwd File.cwd! |> String.replace("flames", "")
  defp file_string(nil), do: nil
  defp file_string(file) when is_binary(file) do
    file
    |> String.replace(@cwd, "")
    |> String.split("/")
    |> file_string()
  end
  defp file_string(["deps", lib | file]) do
    ["(#{lib})" | file]
  end
  defp file_string([lib | file]) do
    ["(#{lib})" | file]
  end

  @args_regex ~r/Args: [.*?]/
  @struct_regex ~r/%.*?{.*?}/
  @function_regex ~r/#Function<\d+\.\d+\/\d+ in .*?\/\d{1}>/
  @pid_regex ~r/#PID<\d+\.\d+\.\d+>/
  @id_regex ~r/id: \d+/
  @dates_regex ~r/#(Ecto\.)?DateTime<.*?>|#<DateTime(.*?)>/
  @hash_ignore_regex ~r/#{@pid_regex.source}|#{@id_regex.source}|#{@dates_regex.source}|#{@function_regex.source}|#{@struct_regex.source}|#{@args_regex.source}/
  def hash(list) when is_list(list), do: list |> hd |> hash
  def hash(msg) when is_binary(msg) do
    msg = msg |> String.replace(@hash_ignore_regex, "")
    :crypto.hash(:sha256, msg) |> Base.encode16
  end
end
