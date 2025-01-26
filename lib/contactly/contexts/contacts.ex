defmodule Contactly.Contacts do
  @moduledoc """
  The Contacts context.
  """
  alias Contactly.Repo
  alias Contactly.Contact
  import Ecto.Query

  @default_page_size 5

  def list_all_contacts(user_id) do
    Contact
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  def list_contacts(user_id, opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    search_query = Keyword.get(opts, :search_query, "")

    Contact
    |> where(user_id: ^user_id)
    |> apply_search(search_query)
    |> paginate(page, @default_page_size)
    |> Repo.all()
  end

  def count_contacts(user_id, search_query \\ "") do
    Contact
    |> where(user_id: ^user_id)
    |> apply_search(search_query)
    |> select([c], count(c.id))
    |> Repo.one()
  end

  defp apply_search(query, ""), do: query

  defp apply_search(query, search_query) do
    search_term = "%#{search_query}%"

    query
    |> where([c], ilike(c.name, ^search_term) or ilike(c.email, ^search_term))
  end

  defp paginate(query, page, page_size) do
    query
    |> limit(^page_size)
    |> offset(^(page_size * (page - 1)))
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
end
