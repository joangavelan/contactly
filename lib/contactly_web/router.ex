defmodule ContactlyWeb.Router do
  use ContactlyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ContactlyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :is_authenticated do
    plug ContactlyWeb.Plugs.RequireAuth
    plug ContactlyWeb.Plugs.FetchUser
  end

  scope "/", ContactlyWeb do
    pipe_through :browser

    get "/", HomeController, :index

    get "/login", AuthController, :login_page
    post "/logout", AuthController, :logout
  end

  scope "/", ContactlyWeb do
    pipe_through [:browser, :is_authenticated]

    get "/portal", PortalController, :index
  end

  scope "/auth", ContactlyWeb do
    pipe_through :browser

    get "/:provider", AuthProviderController, :request
    get "/:provider/callback", AuthProviderController, :callback
  end
end
