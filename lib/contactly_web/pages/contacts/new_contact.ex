defmodule ContactlyWeb.Pages.Contacts.NewContact do
  use ContactlyWeb, :live_view
  import ContactlyWeb.Pages.Contacts.Components
  require Logger
  alias Contactly.Contacts
  alias Contactly.Contact

  def mount(_params, _session, socket) do
    changeset = Contact.changeset(%Contact{}, %{})
    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("save_contact", %{"contact" => contact_params}, socket) do
    case Contacts.create_contact(contact_params) do
      {:ok, _created_contact} ->
        socket =
          socket
          |> put_flash(:info, "Contact created successfully!")
          |> push_navigate(to: "/contacts")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: Map.put(changeset, :action, :insert))}
    end
  end

  def render(assigns) do
    ~H"""
    <.contact_form changeset={@changeset} on_submit="save_contact" submit_btn_text="Save Contact" />

    <.link navigate="/contacts"><button style="margin-top: 20px;">Go Back</button></.link>
    """
  end
end
