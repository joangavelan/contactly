defmodule ContactlyWeb.Pages.Contacts do
  require Logger
  use ContactlyWeb, :live_view
  alias Contactly.Contacts

  def mount(_params, _session, socket) do
    contacts = Contacts.list_contacts()
    {:ok, assign(socket, contacts: contacts)}
  end

  def handle_event("delete_contact", %{"contact_id" => id}, socket) do
    contact = Contacts.get_contact!(id)

    case Contacts.delete_contact(contact) do
      {:ok, _deleted_contact} ->
        updated_contacts = Contacts.list_contacts()

        socket =
          socket
          |> assign(contacts: updated_contacts)
          |> put_flash(:info, "Contact deleted successfully!")

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to delete contact")}
    end
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
        <li>
          <p>{contact.name} - {contact.email} - {contact.phone}</p>

          <div>
            <.link navigate={~p"/contacts/#{contact.id}/edit"}><button>Edit</button></.link>
            <button
              id={"delete-contact-#{contact.id}-btn"}
              data-contact-id={contact.id}
              class="delete-contact-btn"
              phx-hook="OpenDeleteContactModalConfirmation"
            >
              Delete
            </button>
          </div>
        </li>
      <% end %>
    </ul>

    <%!-- Delete confirmation modal --%>
    <div class="delete-contact-modal hidden">
      <div class="modal-content">
        <p>Are you sure you want to delete this contact?</p>
        <div class="modal-buttons">
          <button id="close-modal-btn" phx-click={JS.add_class("hidden", to: ".delete-contact-modal")}>
            Cancel
          </button>
          <form phx-submit="delete_contact">
            <input type="hidden" name="contact_id" id="contact-id-hidden-input" />
            <button id="delete-confirmation-btn" phx-disable-with="Deleting...">Delete</button>
          </form>
        </div>
      </div>
    </div>
    """
  end
end
