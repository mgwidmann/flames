if Code.ensure_loaded?(Phoenix.View) && Code.ensure_loaded?(Phoenix.HTML) do
  defmodule Flames.LayoutView do
    @moduledoc false

    use Flames.Web, :view
  end
else
  IO.puts("Flames.LayoutView: Flames not compiled with either Phoenix.View or Phoenix.HTML!")
end
