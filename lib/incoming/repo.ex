defmodule Incoming.Repo do
  use Ecto.Repo,
    otp_app: :incoming,
    adapter: Ecto.Adapters.Postgres
end
