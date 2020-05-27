# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :incoming,
  ecto_repos: [Incoming.Repo]

# Configures the endpoint
config :incoming, IncomingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0SO+DAITLylGHSDRk5Xh1+ni5KrXbmWpzWl2go3INHvYNkisAYFwLFUYt4b/tfbP",
  render_errors: [view: IncomingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Incoming.PubSub,
  live_view: [signing_salt: "uBCLPQ7A"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :incoming, IncomingWeb.Authentication,
  issuer: "incoming",
  secret_key: "FAKE_SECRET"

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
