defmodule Contactly.Contacts do
  @moduledoc """
  The Contacts context.
  """
  alias Contactly.Repo
  alias Contactly.Contact
  import Ecto.Query

  def list_contacts(user_id, page \\ 1, page_size \\ 5) do
    Contact
    |> where(user_id: ^user_id)
    |> order_by(:name)
    |> limit(^page_size)
    |> offset(^((page - 1) * page_size))
    |> Repo.all()
  end

  def count_contacts(user_id) do
    Contact
    |> where(user_id: ^user_id)
    |> select([c], count(c.id))
    |> Repo.one()
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

  def count_search_results(user_id, query) do
    Contact
    |> where(user_id: ^user_id)
    |> where([c], ilike(c.name, ^"%#{query}%") or ilike(c.email, ^"%#{query}%"))
    |> select([c], count(c.id))
    |> Repo.one()
  end

  def search_contacts_paginated(user_id, query, page \\ 1, page_size \\ 5) do
    Contact
    |> where(user_id: ^user_id)
    |> where([c], ilike(c.name, ^"%#{query}%") or ilike(c.email, ^"%#{query}%"))
    |> order_by(:name)
    |> limit(^page_size)
    |> offset(^((page - 1) * page_size))
    |> Repo.all()
  end
end
