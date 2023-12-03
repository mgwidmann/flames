defmodule Flames.Dashboard.Helpers do
  use Phoenix.Component

  attr :type, :string, default: nil
  attr :color, :atom, default: :red
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot(:inner_block, required: true)

  def button(assigns) do
    ~H"""
    <button
      type={@type || "button"}
      class={[
        "inline-block px-6 py-2.5 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:shadow-lg focus:shadow-lg focus:outline-none focus:ring-0 active:shadow-lg transition duration-150 ease-in-out",
        button_classes_for_color(@color),
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  def button_classes_for_color(:red) do
    "bg-rose-600 active:bg-rose-800 focus:bg-rose-700 hover:bg-rose-700"
  end

  def button_classes_for_color(:amber) do
    "bg-amber-600 active:bg-amber-800 focus:bg-amber-700 hover:bg-amber-700"
  end

  def button_classes_for_color(_) do
    "bg-yellow-500 active:bg-yellow-800 focus:bg-yellow-700 hover:bg-yellow-700"
  end

  attr :level, :string

  def level(assigns) do
    ~H"""
    <span class={[
      "text-xs inline-block py-1 px-2.5 leading-none text-center whitespace-nowrap align-baseline font-bold text-white rounded uppercase",
      color_for_level(@level)
    ]}>
      <%= @level %>
    </span>
    """
  end

  def color_for_level("error"), do: "bg-rose-600"
  def color_for_level("warn"), do: "bg-amber-400"
  def color_for_level("warning"), do: "bg-amber-400"
  def color_for_level(_other), do: "bg-gradient-to-r from-amber-400 to-rose-600"

  def display_timestamp(%DateTime{} = timestamp) do
    timestamp
    |> DateTime.to_naive()
    |> display_timestamp()
  end

  def display_timestamp(%NaiveDateTime{} = timestamp) do
    timezone = Application.get_env(:flames, :timezone, "Etc/UTC")

    timestamp
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.shift_zone!(timezone)
    |> Calendar.strftime("%a %b %d, %Y %I:%M %p")
  end

  def display_module(atom) when is_atom(atom) do
    atom
    |> Atom.to_string()
    |> display_module()
  end

  def display_module(atom) when is_binary(atom) do
    if String.starts_with?(atom, ":") || String.starts_with?(atom, "Elixir.") do
      String.to_existing_atom(atom) |> inspect()
    else
      atom
    end
  end

  def last_incident_timestamp(%Flames.Error{
        incidents: [%Flames.Error.Incident{timestamp: timestamp} | _]
      }) do
    display_timestamp(timestamp)
  end

  def last_incident_timestamp(%Flames.Error{timestamp: timestamp}) do
    display_timestamp(timestamp)
  end

  def last_incident_timestamp(_error) do
    "(Unknown)"
  end
end
