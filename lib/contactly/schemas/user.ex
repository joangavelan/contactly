defmodule Contactly.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, [autogenerate: false]}
  schema "users" do
    field :email, :string
    field :picture, :string
    has_many :contacts, Contactly.Contact
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :email, :picture])
    |> validate_required([:id, :email])
    |> unique_constraint(:email)
  end
end
