defmodule Flames.Error.Worker do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_cast({level, event}, _) do
    handle_event(level, event)
    {:noreply, nil}
  end

  @application_start """

    def start(_type, _args) do
      children = [
        # ...
        MyApplication.Repo,
        Flames.Supervisor # <-- Add this as the first entry after your Repo
        # ...,
      ]

      opts = [strategy: :one_for_one, name: KartVids.Supervisor]
      Supervisor.start_link(children, opts)
    end

  """

  def post_event(level, event) do
    if Process.whereis(__MODULE__) != nil do
      GenServer.cast(__MODULE__, {level, event})
    else
      Logger.warn(
        "Flames worker not started! Please add the following to your application.ex start function: \n#{@application_start}",
        flames: false
      )
    end
  end

  def handle_event(level, data) do
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

  @endpoint_config """

      config :flames,endpoint: MyApplicationWeb.Endpoint

  """

  def broadcast_topic(), do: "errors"

  defp broadcast(error) do
    endpoint = Application.get_env(:flames, :endpoint)

    if endpoint == nil do
      Logger.warn(
        "Flames not configured with endpoint in order to provide live updates! Please add the following configuration to your config.exs or similar: \n#{@endpoint_config}",
        flames: false
      )
    else
      if function_exported?(endpoint, :broadcast, 3) do
        endpoint.broadcast(broadcast_topic(), "error", error)
      else
        Logger.error(
          "Flames unable to broadcast errors because configured module from Application.get_env(:flames, :endpoint) does not export a broadcast/3 function! Endpoint module: #{inspect(endpoint)}",
          flames: false
        )
      end
    end

    error
  end

  @message_regex ~r/^\s*\((?<app>.*?)\) (?<file>.*?):(?<line>\d+): (?<fun>.*)$/m
  defp error_changeset(level, {Logger, msg, {date, {hour, min, sec, _ms}}, md}) do
    repo = Application.get_env(:flames, :repo)
    message = normalize_message(msg)
    hash = hash(message.full)

    timestamp =
      NaiveDateTime.from_erl!({date, {hour, min, sec}}) |> DateTime.from_naive!("Etc/UTC")

    if e = Flames.Error.find_reported(hash) |> repo.one() do
      e
      |> Flames.Error.recur_changeset(%{
        count: e.count + 1,
        incidents: [
          %{message: message.full, timestamp: timestamp}
          | Enum.map(e.incidents, &Map.from_struct/1)
        ]
      })
    else
      {file, fun, line} = analyze(message.full)

      Flames.Error.changeset(%Flames.Error{}, %{
        message: message.full,
        level: to_string(level),
        timestamp: timestamp,
        alive: Process.alive?(md[:pid]),
        module: (md[:module] && to_string(md[:module])) || message.module,
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

  defp normalize_message(full_message = [message, stack, fun | args])
       when is_binary(stack) or is_list(stack) do
    %{
      message: IO.chardata_to_string(message),
      stack: IO.chardata_to_string(stack),
      module: fun |> IO.chardata_to_string() |> String.trim() |> String.replace("Function: ", ""),
      args: args |> IO.chardata_to_string() |> String.trim() |> String.replace("Args: ", ""),
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
    |> String.replace(File.cwd!() |> String.replace("flames", ""), "")
    |> String.split("/", trim: true)
    |> file_string()
    |> Enum.join("/")
  end

  # Heroku
  defp file_string(["tmp", build = "build_" <> _some_number | path]),
    do: file_string([build | path])

  defp file_string(["deps", lib | file]) do
    ["(#{lib}) " | file]
  end

  defp file_string([lib | file]) when is_binary(lib) do
    ["(#{lib}) " | file]
  end

  defp file_string(list), do: list

  @args_regex ~r/Args: \[.*?\]/
  @struct_regex ~r/%.*?{.*?}/
  @tuple_regex ~r/{.*?}/
  @function_regex ~r/#Function<\d+\.\d+\/\d+ in .*?\/\d{1}>/
  @pid_regex ~r/#PID<\d+\.\d+\.\d+>/
  @ref_regex ~r/#Reference<\d+\.\d+\.\d+\.\d+>/
  @port_regex ~r/#Port<\d+\.\d+>/
  @id_regex ~r/id: "?\d+"?/
  @string_regex ~r/".*?"|'.*?'/
  @number_regex ~r/\d+/
  @dates_regex ~r/#(Ecto\.)?DateTime<.*?>|#<DateTime(.*?)>/
  @data_equals_regex ~r/Data == .*?\*\*/
  @state_equals_regex ~r/State == .*?\*\*/
  @hash_ignore_regex ~r/#{@state_equals_regex.source}|#{@data_equals_regex.source}|#{@pid_regex.source}|#{@ref_regex.source}|#{@port_regex.source}|#{@struct_regex.source}|#{@tuple_regex.source}|#{@id_regex.source}|#{@function_regex.source}|#{@args_regex.source}|#{@string_regex.source}|#{@number_regex.source}|#{@dates_regex.source}/
  def hash_ignore_regex(), do: @hash_ignore_regex
  def strip_variable_data(msg), do: msg |> String.replace(hash_ignore_regex(), "")
  def hash(list) when is_list(list), do: list |> hd |> hash

  def hash(msg) when is_binary(msg) do
    msg = strip_variable_data(msg)
    :crypto.hash(:sha256, msg) |> Base.encode16()
  end
end
