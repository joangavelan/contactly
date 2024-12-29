defmodule ContactlyWeb.Pages.Contacts do
  alias Contactly.Contact
  use Phoenix.LiveView
  require Logger
  import ContactlyWeb.Pages.Contacts.Components

  def mount(_params, _session, socket) do
    changeset = Contact.changeset(%Contact{}, %{}) |> Map.put(:action, :initial_form)
    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"contact_form" => contact_form_data}, socket) do
    changeset = Contact.changeset(%Contact{}, contact_form_data) |> Map.put(:action, :insert)

    if changeset.valid? do
      # Save contact to the database
      Logger.info("Saving contact to the database...")

      {:noreply, assign(socket, changeset: Contact.changeset(%Contact{}, %{}))}
    else
      # Return errors to the form
      {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <h1>Contacts</h1>

    <.contact_form changeset={@changeset} />
    """
  end
end
