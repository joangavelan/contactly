defmodule ContactlyWeb.ContactsController do
  use ContactlyWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
