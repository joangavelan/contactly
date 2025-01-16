defmodule Contactly.Users do
  @moduledoc """
  The Users Context
  """
  alias Contactly.User
  alias Contactly.Repo

  def upsert_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace_all_except, [:id]},
      conflict_target: :id
    )
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end
end
