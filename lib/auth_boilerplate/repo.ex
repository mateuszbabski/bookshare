defmodule AuthBoilerplate.Repo do
  use Ecto.Repo,
    otp_app: :auth_boilerplate,
    adapter: Ecto.Adapters.Postgres
end
