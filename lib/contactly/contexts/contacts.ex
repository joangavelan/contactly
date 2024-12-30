defmodule Contactly.Contacts do
  @moduledoc """
  The Contacts context.
  """
  alias Contactly.Repo
  alias Contactly.Contact

  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end
end
