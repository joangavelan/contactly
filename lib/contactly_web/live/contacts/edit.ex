defmodule ContactlyWeb.Live.Contacts.Edit do
  alias Contactly.Contact
  alias Contactly.Contacts
  use ContactlyWeb, :live_view
  import ContactlyWeb.Live.Components

  def mount(%{"id" => contact_id}, _session, socket) do
    user_id = socket.assigns.current_user.id
    contact = Contacts.get_contact!(user_id, contact_id)

    changeset = Contact.changeset(contact)

    socket = assign(socket, changeset: changeset)

    {:ok, socket}
  end

  def handle_event("update_contact", %{"contact" => contact_params}, socket) do
    user_id = socket.assigns.current_user.id
    contact_id = contact_params["id"]
    contact = Contacts.get_contact!(user_id, contact_id)

    case Contacts.update_contact(contact, contact_params) do
      {:ok, updated_contact} ->
        socket =
          socket
          |> put_flash(:info, "Contact updated successfully!")
          |> push_navigate(to: "/live/contacts/#{updated_contact.id}")

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, changeset: changeset)

        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <.link navigate="/live/contacts">
        <button>Back</button>
      </.link>

      <h1>Edit Contact</h1>

      <.contact_form
        on_submit="update_contact"
        changeset={@changeset}
        submit_btn_text="Update Contact"
        submitting_btn_text="Updating..."
      />
    </div>
    """
  end
end
