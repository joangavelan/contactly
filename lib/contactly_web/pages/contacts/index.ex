defmodule ContactlyWeb.Pages.Contacts do
  require Logger
  use ContactlyWeb, :live_view
  alias Contactly.Contacts

  def mount(_params, _session, socket) do
    contacts = Contacts.list_contacts()
    {:ok, assign(socket, contacts: contacts)}
  end

  def render(assigns) do
    ~H"""
    <h1>Contacts</h1>

    <.link navigate={~p"/contacts/new"}>
      <button>New contact</button>
    </.link>

    <h2>List</h2>
    <ul>
      <%= for contact <- @contacts do %>
        <li>{contact.name} - {contact.email} - {contact.phone}</li>
      <% end %>
    </ul>
    """
  end
end
