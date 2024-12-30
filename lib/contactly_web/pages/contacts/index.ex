defmodule ContactlyWeb.Pages.Contacts do
  alias Contactly.Contacts
  alias Contactly.Contact
  use Phoenix.LiveView
  require Logger
  import ContactlyWeb.Pages.Contacts.Components

  def mount(_params, _session, socket) do
    changeset = Contact.changeset(%Contact{}, %{}) |> Map.put(:action, :initial_form)
    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"contact_form" => contact_form_data}, socket) do
    case Contacts.create_contact(contact_form_data) do
      {:ok, created_contact} ->
        Logger.info("Contact #{created_contact.email} saved to the database")

        {:noreply, assign(socket, changeset: Contact.changeset(%Contact{}, %{}))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: Map.put(changeset, :action, :insert))}
    end
  end

  def render(assigns) do
    ~H"""
    <h1>Contacts</h1>

    <.contact_form changeset={@changeset} />
    """
  end
end
