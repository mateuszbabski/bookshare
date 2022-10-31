defmodule Bookshare.Repo do
  use Ecto.Repo,
    otp_app: :bookshare,
    adapter: Ecto.Adapters.Postgres
end
