defmodule Htzn.Repo do
  use Ecto.Repo,
    otp_app: :htzn,
    adapter: Ecto.Adapters.Postgres
end
