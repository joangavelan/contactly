defmodule ContactlyWeb.Pages.Contacts.EditContact do
  use ContactlyWeb, :live_view
  require Logger
  alias Contactly.Contacts
  alias Contactly.Contact
  import ContactlyWeb.Pages.Contacts.Components

  def mount(%{"id" => id}, _session, socket) do
    contact = Contacts.get_contact!(id)
    changeset = Contact.changeset(contact, %{})

    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("update_contact", %{"contact" => contact_params}, socket) do
    contact = Contacts.get_contact!(contact_params["id"])

    case Contacts.update_contact(contact, contact_params) do
      {:ok, _updated_contact} ->
        socket =
          socket
          |> put_flash(:info, "Contact updated successfully!")
          |> push_navigate(to: "/contacts")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: Map.put(changeset, :action, :update))}
    end
  end

  def render(assigns) do
    ~H"""
    <.contact_form changeset={@changeset} on_submit="update_contact" submit_btn_text="Update Contact" />

    <.link navigate="/contacts"><button style="margin-top: 20px;">Go back</button></.link>
    """
  end
end
