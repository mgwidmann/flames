defmodule Flames.Router do
  @moduledoc """
  Provies LiveView routing for the Flames dashboard.
  """

  @doc """
  It expects the `path` the dashboard will be mounted at
  and a set of options.

  This will also generate a named helper called `live_dashboard_path/2`
  which you can use to link directly to the dashboard, such as:

      <%= link "Dashboard", to: live_dashboard_path(conn, :home) %>

  Note you should only use `link/2` to link to the dashboard (and not
  `live_redirect/live_link`, as it has to set its own session on first
  render.

  ## Options
    * `:live_socket_path` - Configures the socket path. it must match
      the `socket "/live", Phoenix.LiveView.Socket` in your endpoint.
    * `:csp_nonce_assign_key` - an assign key to find the CSP nonce
      value used for assets. Supports either `atom()` or a map of
      type `%{optional(:img) => atom(), optional(:script) => atom(), optional(:style) => atom()}`

  ## Examples

    defmodule MyAppWeb.Router do
      use Phoenix.Router
      import Flames.Router

      scope "/admin", MyAppWeb do
        # Define require_admin plug to ensure public users cannot get here
        pipe_through [:browser, :require_admin]

        flames "/errors"
      end
    end
  """
  defmacro flames(path, opts \\ []) do
    # Copied most of this from https://github.com/phoenixframework/phoenix_live_dashboard/blob/master/lib/phoenix/live_dashboard/router.ex
    opts =
      if Macro.quoted_literal?(opts) do
        Macro.prewalk(opts, &expand_alias(&1, __CALLER__))
      else
        opts
      end

    live_socket_path = Keyword.get(opts, :live_socket_path, "/live")

    csp_nonce_assign_key =
      case opts[:csp_nonce_assign_key] do
        nil -> nil
        key when is_atom(key) -> %{img: key, style: key, script: key}
        %{} = keys -> Map.take(keys, [:img, :style, :script])
      end

    quote bind_quoted: binding() do
      scope path, alias: false, as: false do
        import Phoenix.LiveView.Router, only: [live: 4, live_session: 3]

        live_session :flames,
          root_layout: {Flames.Dashboard.LayoutView, :dashboard},
          session: {Flames.Router, :__session__, [csp_nonce_assign_key]} do
          live "/", Flames.Dashboard.ErrorsLive, :home,
            as: :flames,
            private: %{
              live_socket_path: live_socket_path,
              csp_nonce_assign_key: csp_nonce_assign_key
            }

          live "/:error", Flames.Dashboard.ErrorsLive, :error,
            as: :flames,
            private: %{
              live_socket_path: live_socket_path,
              csp_nonce_assign_key: csp_nonce_assign_key
            }
        end
      end
    end
  end

  defp expand_alias({:__aliases__, _, _} = alias, env),
    do: Macro.expand(alias, %{env | function: {:flames, 2}})

  defp expand_alias(other, _env), do: other

  def __session__(conn, csp_nonce_assign_key) do
    %{
      "csp_nonces" => %{
        img: conn.assigns[csp_nonce_assign_key[:img]],
        style: conn.assigns[csp_nonce_assign_key[:style]],
        script: conn.assigns[csp_nonce_assign_key[:script]]
      }
    }
  end
end
