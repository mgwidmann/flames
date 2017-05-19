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
    repo = Application.get_env(:flames, :repo)
    try do
      level
      |> error_changeset(data)
      |> repo.insert_or_update!()
      |> broadcast()
    rescue
      error ->
        Logger.error(Exception.format(:error, error), flames: false)
        {:error, error}
    catch
      error ->
        Logger.error(error, flames: false)
        {:error, error}
    end
  end

  defp broadcast(error) do
    endpoint = Application.get_env(:flames, :endpoint)
    endpoint && endpoint.broadcast("errors", "error", error)
    error
  end

  defp configure(options \\ []) do
    options = Keyword.merge(options, [])
    flames_config = Keyword.merge(Application.get_env(:logger, :flames, []), options)
    Application.put_env(:logger, :flames, flames_config)
  end

  @message_regex ~r/^\s*\((?<app>.*?)\) (?<file>.*?):(?<line>\d+): (?<fun>.*)$/m
  defp error_changeset(level, {Logger, msg, {date, {hour, min, sec, _ms}}, md}) do
    repo = Application.get_env(:flames, :repo)
    message = normalize_message(msg)
    hash = hash(message.full)
    if e = Flames.Error.find_reported(hash) |> repo.one() do
      e
      |> Flames.Error.recur_changeset(%{
        count: e.count + 1,
        incidents: [%{message: message.full, timestamp: {date, {hour, min, sec}}} | Enum.map(e.incidents, &Map.from_struct/1)]
      })
    else
      {file, fun, line} = analyze(message.full)
      Flames.Error.changeset(%Flames.Error{}, %{
        message: message.full,
        level: to_string(level),
        timestamp: {date, {hour, min, sec}},
        alive: Process.alive?(md[:pid]),
        module: md[:module] && to_string(md[:module]) || message.module,
        function: md[:function] || fun,
        file: md[:file] |> file_string() || file,
        line: md[:line] || line,
        hash: hash,
        count: 1
      })
    end
  end

  defp analyze(message) do
    case Regex.named_captures(@message_regex, message) do
      %{"file" => file, "line" => line, "fun" => fun} -> {file, fun, line}
      nil -> {nil, nil, nil}
    end
  end

  defp normalize_message(full_message = [message, stack, fun | args]) when is_binary(stack) or is_list(stack) do
    %{
      message: IO.chardata_to_string(message),
      stack: IO.chardata_to_string(stack),
      module: fun |> IO.chardata_to_string() |> String.strip() |> String.replace("Function: ", ""),
      args: args |> IO.chardata_to_string() |> String.strip() |> String.replace("Args: ", ""),
      full: IO.chardata_to_string(full_message)
    }
  end
  defp normalize_message(message) do
    %{
      message: IO.chardata_to_string(message),
      stack: nil,
      module: nil,
      args: nil,
      full: IO.chardata_to_string(message)
    }
  end

  defp file_string(nil), do: nil
  defp file_string(file) when is_binary(file) do
    file
    |> String.replace(File.cwd! |> String.replace("flames", ""), "")
    |> String.split("/", trim: true)
    |> file_string()
    |> Enum.join("/")
  end
  # Heroku
  defp file_string(["tmp", build = "build_" <> _some_number | path]), do: file_string([build | path])
  defp file_string(["deps", lib | file]) do
    ["(#{lib}) " | file]
  end
  defp file_string([lib | file]) when is_binary(lib) do
    ["(#{lib}) " | file]
  end
  defp file_string(list), do: list

  @args_regex ~r/Args: \[.*?\]/
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
