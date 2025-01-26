defmodule ContactlyWeb.LiveHooks.RequireAuth do
  import Phoenix.Component
  import Phoenix.LiveView
  alias Contactly.Users

  def on_mount(:default, _params, %{"user_id" => user_id} = _session, socket) do
    {:cont, assign_new(socket, :current_user, fn -> Users.get_user!(user_id) end)}
  end

  def on_mount(:default, _params, _session, socket) do
    {:halt, redirect(socket, to: "/login")}
  end
end
