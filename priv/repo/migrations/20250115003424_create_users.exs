defmodule Contactly.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, primary_key: true
      add :email, :string
      add :picture, :string
    end

    create unique_index(:users, [:email])
  end
end
