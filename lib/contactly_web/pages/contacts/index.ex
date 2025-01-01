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
    <%!-- feedback message (flash) --%>
    <%= if msg = Phoenix.Flash.get(@flash, :info) do %>
      <div id="flash-info">
        Info: {msg}
        <button phx-click={
          JS.push("lv:clear-flash", value: %{key: :info}) |> JS.hide(to: "#flash-info")
        }>
          x
        </button>
      </div>
    <% end %>

    <h1>Contacts</h1>

    <.link navigate={~p"/contacts/new"}>
      <button>New contact</button>
    </.link>

    <h2>List</h2>
    <ul>
      <%= for contact <- @contacts do %>
        <li>
          <p>{contact.name} - {contact.email} - {contact.phone}</p>

          <div>
            <.link navigate={~p"/contacts/#{contact.id}/edit"}><button>Edit</button></.link>
          </div>
        </li>
      <% end %>
    </ul>
    """
  end
end
