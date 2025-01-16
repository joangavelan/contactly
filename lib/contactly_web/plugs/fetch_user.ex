defmodule ContactlyWeb.Plugs.FetchUser do
  import Plug.Conn
  alias Contactly.Users

  def init(default), do: default

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = Users.get_user!(user_id)
    assign(conn, :current_user, user)
  end
end
