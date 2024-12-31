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

  def handle_event("save", %{"contact_form" => contact_form_data}, socket) do
    case Contacts.create_contact(contact_form_data) do
      {:ok, _created_contact} ->
        socket =
          socket
          |> push_navigate(to: "/contacts")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: Map.put(changeset, :action, :insert))}
    end
  end

  def render(assigns) do
    ~H"""
    <.contact_form changeset={@changeset} />

    <.link navigate={~p"/contacts"}>
      <button style="margin-top: 20px;">Go Back</button>
    </.link>
    """
  end
end
