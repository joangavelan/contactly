defmodule Contactly.Contacts do
  @moduledoc """
  The Contacts context.
  """
  alias Contactly.Repo
  alias Contactly.Contact
  import Ecto.Query, only: [from: 2]

  def list_contacts(user_id) do
    Repo.all(from c in Contact, where: c.user_id == ^user_id)
  end

  def create_contact(user_id, attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(Map.put(attrs, "user_id", user_id))
    |> Repo.insert()
  end

  def get_contact!(user_id, contact_id) do
    Repo.get_by!(Contact, user_id: user_id, id: contact_id)
  end

  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  def generate_csv(contacts) do
    headers = ["name", "email", "phone"]
    rows = Enum.map(contacts, &[&1.name, &1.email, &1.phone])

    [headers | rows]
    |> CSV.encode()
    |> Enum.join()
  end

  def search_contacts(user_id, query) do
    query =
      from c in Contact,
        where:
          c.user_id == ^user_id and
            (ilike(c.name, ^"%#{query}%") or ilike(c.email, ^"%#{query}%"))

    Repo.all(query)
  end
end
