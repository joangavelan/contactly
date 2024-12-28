defmodule ContactlyWeb.Pages.Contacts do
  use Phoenix.LiveView
  require Logger

  import ContactlyWeb.Pages.Contacts.Components

  def handle_event("save", %{"contact_form" => contact_form_data}, socket) do
    Logger.info("Form submitted: #{inspect(contact_form_data)}")
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Contacts</h1>

    <.contact_form />
    """
  end
end
