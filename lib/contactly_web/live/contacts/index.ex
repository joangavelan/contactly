defmodule ContactlyWeb.Live.Contacts.Index do
  use ContactlyWeb, :live_view
  alias Contactly.Contacts
  require Logger
  import ContactlyWeb.Live.Components
  import ContactlyWeb.GlobalComponents

  @default_page_size 5

  def mount(_params, _session, socket) do
    socket = allow_upload(socket, :csv_file, accept: ~w(.csv), max_entries: 1)

    {:ok, socket}
  end

  def handle_params(params, uri, socket) do
    user_id = socket.assigns.current_user.id

    search_query = Map.get(params, "search_query", "")
    page_number = Map.get(params, "page", "1") |> String.to_integer()

    opts = [search_query: search_query, page: page_number]

    contacts = Contacts.list_contacts(user_id, opts)
    total_contacts = Contacts.count_contacts(user_id, search_query)

    total_pages = ceil(total_contacts / @default_page_size)

    parsed_uri = URI.parse(uri)

    relative_uri =
      case parsed_uri.query do
        nil -> parsed_uri.path
        q -> parsed_uri.path <> "?" <> q
      end

    socket =
      assign(socket,
        contacts: contacts,
        total_pages: total_pages,
        current_page: page_number,
        search_query: search_query,
        relative_uri: relative_uri
      )

    {:noreply, socket}
  end

  def handle_event("search", %{"search_query" => ""}, socket) do
    socket = push_patch(socket, to: "/live/contacts")

    {:noreply, socket}
  end

  def handle_event("search", %{"search_query" => search_query}, socket) do
    socket = push_patch(socket, to: "/live/contacts?search_query=#{search_query}")

    {:noreply, socket}
  end

  def handle_event("delete_contact", %{"contact_id" => contact_id}, socket) do
    user_id = socket.assigns.current_user.id
    contact = Contacts.get_contact!(user_id, contact_id)
    current_path = socket.assigns.relative_uri

    case Contacts.delete_contact(contact) do
      {:ok, _deleted_contact} ->
        socket =
          socket
          |> put_flash(:info, "Contact deleted successfully!")
          |> push_event(:contact_deleted, %{})
          |> push_patch(to: current_path)

        {:noreply, socket}

      {:error, _changeset} ->
        socket =
          socket
          |> put_flash(:error, "Failed to delete contact")
          |> push_patch(to: current_path)

        {:noreply, socket}
    end
  end

  def handle_event("validate_csv", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("upload_csv", _params, socket) do
    user_id = socket.assigns.current_user.id

    consume_uploaded_entries(socket, :csv_file, fn %{path: path}, _entry ->
      path
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> Enum.each(fn
        {:ok, contact} -> Contacts.create_contact(user_id, contact)
        {:error, _reason} -> :skip
      end)

      {:ok, "Contacts successfully imported"}
    end)

    socket =
      socket
      |> put_flash(:info, "Contacts successfully imported!")
      |> push_patch(to: "/live/contacts")

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.link href="/portal">
      <button>Back to Portal</button>
    </.link>

    <.welcome_user current_user={@current_user} />

    <h1>Contacts</h1>

    <.link navigate="/live/contacts/new">
      <button>New contact</button>
    </.link>

    <div>
      <div>
        <h2>Import Contacts (CSV)</h2>

        <form phx-submit="upload_csv" phx-change="validate_csv">
          <.live_file_input upload={@uploads.csv_file} />
          <button phx-disable-with="Importing...">Import</button>
        </form>
      </div>

      <div>
        <h2>Export Contacts</h2>
        <a href="/mvc/contacts/export" download>
          <button>Export</button>
        </a>
      </div>
    </div>

    <div>
      <h2>List</h2>

      <form phx-change="search">
        <input
          type="text"
          name="search_query"
          placeholder="Search contacts..."
          phx-debounce="300"
          value={@search_query}
        />
      </form>

      <ul>
        <%= for contact <- @contacts do %>
          <li>
            <p>{contact.name} - {contact.email} - {contact.phone}</p>

            <div>
              <.link navigate={"/live/contacts/#{contact.id}"}>
                <button>View</button>
              </.link>

              <.link navigate={"/live/contacts/#{contact.id}/edit"}>
                <button>Edit</button>
              </.link>

              <button
                id={"delete-contact-#{contact.id}-btn"}
                data-contact-id={contact.id}
                phx-hook="OpenDeleteContactModalConfirmation"
              >
                Delete
              </button>
            </div>
          </li>
        <% end %>
      </ul>
    </div>

    <%= if @total_pages && @total_pages > 1 do %>
      <nav>
        <%= for i <- 1..@total_pages do %>
          <.link patch={
            if @search_query != "" do
              "/live/contacts?search_query=#{@search_query}&page=#{i}"
            else
              "/live/contacts?page=#{i}"
            end
          }>
            <button>{i}</button>
          </.link>
        <% end %>
      </nav>
    <% end %>

    <.delete_contact_modal />
    """
  end
end
