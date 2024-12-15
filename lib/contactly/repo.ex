defmodule Contactly.Repo do
  use Ecto.Repo,
    otp_app: :contactly,
    adapter: Ecto.Adapters.Postgres
end
