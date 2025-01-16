defmodule ContactlyWeb.PortalController do
  use ContactlyWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
