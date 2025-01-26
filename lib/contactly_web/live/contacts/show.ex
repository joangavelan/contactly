defmodule ContactlyWeb.Live.Contacts.Show do
  use ContactlyWeb, :live_view
  alias Contactly.Contacts
  import ContactlyWeb.Live.Components

  def mount(%{"id" => contact_id}, _session, socket) do
    user_id = socket.assigns.current_user.id
    contact = Contacts.get_contact!(user_id, contact_id)
    socket = assign(socket, contact: contact)

    {:ok, socket}
  end

  def handle_event("delete_contact", %{"contact_id" => contact_id}, socket) do
    user_id = socket.assigns.current_user.id
    contact = Contacts.get_contact!(user_id, contact_id)

    case Contacts.delete_contact(contact) do
      {:ok, _deleted_contact} ->
        socket =
          socket
          |> put_flash(:info, "Contact deleted successfully!")
          |> push_event(:contact_deleted, %{})
          |> push_navigate(to: "/live/contacts")

        {:noreply, socket}

      {:error, _changeset} ->
        socket = put_flash(socket, :error, "Failed to delete contact")

        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <.link navigate="/live/contacts">
      <button>Back</button>
    </.link>

    <h1>Contact Details</h1>

    <div>
      <p>Email: {@contact.email}</p>
      <p>Phone: {@contact.phone}</p>
    </div>

    <div>
      <.link href={"/live/contacts/#{@contact.id}/edit"}>
        <button>Edit</button>
      </.link>

      <button
        id={"delete-contact-#{@contact.id}-btn"}
        data-contact-id={@contact.id}
        phx-hook="OpenDeleteContactModalConfirmation"
      >
        Delete
      </button>
    </div>

    <.delete_contact_modal />
    """
  end
end
