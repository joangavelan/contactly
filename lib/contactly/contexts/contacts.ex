defmodule Contactly.Contacts do
  alias Contactly.Repo
  alias Contactly.Contact

  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  def change_contact(contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end
end
