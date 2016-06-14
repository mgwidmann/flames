if Code.ensure_loaded?(Phoenix.View) && Code.ensure_loaded?(Phoenix.HTML) do
  defmodule Flames.ErrorsView do
    @moduledoc false

    use Flames.Web, :view

    def render("index.json", %{errors: errors}) do
      errors
    end

    def render("show.json", %{error: error}) do
      %{error: error}
    end
  end
end
