defmodule Contactly.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :name, :string
    field :email, :string
    field :phone, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :phone])
    |> validate_required([:name, :email, :phone])
    |> validate_format(:email, ~r/@/, message: "must be a valid email")
    |> validate_length(:phone, is: 9, message: "must be exactly 9 digits")
  end
end
