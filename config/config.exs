# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :bookshare,
  ecto_repos: [Bookshare.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :bookshare, BookshareWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BookshareWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Bookshare.PubSub,
  live_view: [signing_salt: "CrTer8rl"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :bookshare, Bookshare.Mailer,
  adapter: Swoosh.Adapters.Sendinblue,
  api_key: System.get_env("MAILER_API_KEY")

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, Swoosh.ApiClient.Hackney

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
