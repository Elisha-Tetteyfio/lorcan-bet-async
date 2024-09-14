defmodule Lorcan.Repo do
  use Ecto.Repo,
    otp_app: :lorcan,
    adapter: Ecto.Adapters.Postgres
end
