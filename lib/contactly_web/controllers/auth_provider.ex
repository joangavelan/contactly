defmodule ContactlyWeb.AuthProviderController do
  use ContactlyWeb, :controller

  require Logger
  alias Contactly.Users
  alias Assent.Strategy.Google

  @config [
    client_id: System.get_env("GOOGLE_CLIENT_ID"),
    client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
    redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")
  ]

  def request(conn, %{"provider" => "google"}) do
    @config
    |> Google.authorize_url()
    |> case do
      {:ok, %{url: url, session_params: session_params}} ->
        conn
        |> put_session(:session_params, session_params)
        |> redirect(external: url)

      {:error, error} ->
        Logger.error("Authorization URL generation failed: #{inspect(error)}")

        conn
        |> put_flash(:error, "Something went wrong generating the request authorization url")
        |> redirect(to: "/login")
    end
  end

  def callback(conn, %{"provider" => "google"} = params) do
    session_params = get_session(conn, :session_params)
    config = Keyword.put(@config, :session_params, session_params)

    with {:ok, %{user: gu}} <- Google.callback(config, params),
         {:ok, user} <-
           Users.upsert_user(%{id: gu["sub"], email: gu["email"], picture: gu["picture"]}) do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Successfully authenticated with Google")
      |> redirect(to: "/portal")
    else
      {:error, error} ->
        Logger.error("Authentication callback failed: #{inspect(error)}")

        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/login")
    end
  end
end
