if Code.ensure_loaded?(Phoenix.View) && Code.ensure_loaded?(Phoenix.HTML) do
  defmodule Flames.ErrorsView do
    @moduledoc false

    use Flames.Web, :view

    def render("index.json", %{errors: errors}) do
      errors
      |> Enum.map(&index_error/1)
    end

    def render("show.json", %{error: error}) do
      %{error: error}
    end

    defp index_error(error) do
      %{
        id: error.id,
        message: error.message,
        level: error.level,
        timestamp: error.timestamp,
        alive: error.alive,
        module: error.module,
        function: error.function,
        file: error.file,
        line: error.line,
        count: error.count,
        hash: error.hash
      }
    end
  end
end
