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

  scope "/mvc", ContactlyWeb do
    pipe_through [:browser, :is_authenticated]

    post "/contacts/import", ContactsController, :import
    get "/contacts/export", ContactsController, :export

    # get "/contacts", ContactsController, :index
    # get "/contacts/:id/edit", ContactsController, :edit
    # get "/contacts/new", ContactsController, :new
    # get "/contacts/:id, ContactsController, :show
    # post "/contacts", ContactsController, :create
    # patch "/contacts/:id", ContactsController, :update
    # put "/contacts/:id", ContactsController, :update
    # delete "/contacts/:id", ContactsController, :delete

    # Generates all of the routes listed above
    resources "/contacts", ContactsController
  end

  live_session :protected_liveviews, on_mount: ContactlyWeb.LiveHooks.RequireAuth do
    scope "/live", ContactlyWeb do
      pipe_through :browser

      live "/contacts", Live.Contacts.Index
      live "/contacts/:id/edit", Live.Contacts.Edit
      live "/contacts/new", Live.Contacts.New
      live "/contacts/:id", Live.Contacts.Show
    end
  end
end
