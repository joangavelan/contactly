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

  scope "/", ContactlyWeb do
    pipe_through :browser

    get "/", HomeController, :index
  end
end
