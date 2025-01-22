defmodule ContactlyWeb.ContactsController do
  alias Contactly.Contact
  alias Contactly.Contacts
  use ContactlyWeb, :controller

  def index(conn, _params) do
    user_contacts = conn.assigns.current_user.id |> Contacts.list_contacts()
    render(conn, :index, contacts: user_contacts)
  end

  def edit(conn, %{"id" => contact_id}) do
    changeset =
      conn.assigns.current_user.id
      |> Contacts.get_contact!(contact_id)
      |> Contact.changeset()

    render(conn, :edit, changeset: changeset)
  end

  def new(conn, _params) do
    changeset = Contact.changeset(%Contact{})
    render(conn, :new, changeset: changeset)
  end

  def show(conn, %{"id" => contact_id}) do
    contact = conn.assigns.current_user.id |> Contacts.get_contact!(contact_id)
    render(conn, :show, contact: contact)
  end

  def create(conn, %{"contact" => contact_params}) do
    user_id = conn.assigns.current_user.id

    case Contacts.create_contact(user_id, contact_params) do
      {:ok, _created_contact} ->
        conn
        |> put_flash(:info, "Contact created successfully!")
        |> redirect(to: "/mvc/contacts")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def update(conn, %{"id" => contact_id, "contact" => contact_params}) do
    user_id = conn.assigns.current_user.id
    contact = Contacts.get_contact!(user_id, contact_id)

    case Contacts.update_contact(contact, contact_params) do
      {:ok, _updated_contact} ->
        conn
        |> put_flash(:info, "Contact updated successfully!")
        |> redirect(to: "/mvc/contacts")

      {:error, changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => contact_id}) do
    user_id = conn.assigns.current_user.id
    contact = Contacts.get_contact!(user_id, contact_id)

    case Contacts.delete_contact(contact) do
      {:ok, _deleted_contact} ->
        conn
        |> put_flash(:info, "Contact deleted sucessfully!")
        |> redirect(to: "/mvc/contacts")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to delete contact")
        |> redirect(to: "/mvc/contacts")
    end
  end

  def export(conn, _params) do
    csv =
      conn.assigns.current_user.id
      |> Contacts.list_contacts()
      |> Contacts.generate_csv()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=contacts.csv")
    |> send_resp(200, csv)
  end

  def import(conn, %{"file" => %Plug.Upload{path: path, content_type: "text/csv"}}) do
    user_id = conn.assigns.current_user.id

    path
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Enum.each(fn
      {:ok, contact} -> Contacts.create_contact(user_id, contact)
      {:error, _reason} -> :skip
    end)

    conn
    |> put_flash(:info, "Contacts imported successfully!")
    |> redirect(to: "/mvc/contacts")
  end
end
