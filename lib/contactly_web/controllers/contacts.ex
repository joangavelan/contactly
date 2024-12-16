defmodule ContactlyWeb.ContactsController do
  use ContactlyWeb, :controller

  alias Contactly.Contact
  alias Contactly.Contacts

  def index(conn, _params) do
    render(conn, :index)
  end

  def new(conn, _params) do
    changeset = Contacts.change_contact(%Contact{})
    render(conn, :new, changeset: changeset)
  end
end
