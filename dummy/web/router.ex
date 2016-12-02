defmodule Dummy.Router do
  use Dummy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # TODO: Figure out why this has to be disabled...
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :browser # Use the default browser stack

    get "/", Dummy.RedirectController, :index
    get "/test", Dummy.TestController, :index

    scope "/deeply/nested" do
      forward "/errors", Flames.Web
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Dummy do
  #   pipe_through :api
  # end
end
