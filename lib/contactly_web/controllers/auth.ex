defmodule ContactlyWeb.AuthController do
  use ContactlyWeb, :controller

  def login_page(conn, _params) do
    if get_session(conn, :user_id) do
      redirect(conn, to: "/portal")
    else
      render(conn, :login)
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "You have been logged out")
    |> redirect(to: "/login")
  end
end
