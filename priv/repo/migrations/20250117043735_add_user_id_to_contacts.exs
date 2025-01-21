defmodule Contactly.Repo.Migrations.AddUserIdToContacts do
  use Ecto.Migration

  def change do
    alter table("contacts") do
      add :user_id, references("users", type: :string, on_delete: :delete_all), null: false
    end

    create index("contacts", [:user_id])
  end
end
