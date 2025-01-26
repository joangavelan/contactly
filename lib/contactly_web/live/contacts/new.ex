defmodule ContactlyWeb.Live.Contacts.New do
  use ContactlyWeb, :live_view
  import ContactlyWeb.Live.Components
  require Logger
  alias Contactly.Contacts
  alias Contactly.Contact

  def mount(_params, _session, socket) do
    changeset = Contact.changeset(%Contact{})
    socket = assign(socket, changeset: changeset)

    {:ok, socket}
  end

  def handle_event("save_contact", %{"contact" => contact_params}, socket) do
    user_id = socket.assigns.current_user.id

    case Contacts.create_contact(user_id, contact_params) do
      {:ok, created_contact} ->
        socket =
          socket
          |> put_flash(:info, "Contact created successfully!")
          |> push_navigate(to: "/live/contacts/#{created_contact.id}")

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, changeset: changeset)

        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <.link navigate="/live/contacts">
      <button>Go Back</button>
    </.link>

    <.contact_form
      on_submit="save_contact"
      changeset={@changeset}
      submit_btn_text="Save Contact"
      submitting_btn_text="Saving..."
    />
    """
  end
end
