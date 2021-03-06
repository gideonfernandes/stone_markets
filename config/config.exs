# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :stone_markets,
  ecto_repos: [StoneMarkets.Repo]

config :stone_markets, StoneMarkets.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

config :stone_markets, StoneMarkets.ExchangeCurrency,
  exchangerate_api_adapter: StoneMarkets.ExchangerateApi.Client

config :stone_markets, StoneMarketsWeb.Auth.Guardian,
  issuer: "stone_markets",
  secret_key: "TXXAFr6h/o26LsHDdZWvX3izhZpRzHsHtsqLhfMPwYhHn4Wh7yTySKjHZFc+t9zb"

config :stone_markets, StoneMarketsWeb.Auth.Pipeline,
  module: StoneMarketsWeb.Auth.Guardian,
  error_handler: StoneMarketsWeb.Auth.ErrorHandler

# Configures the endpoint
config :stone_markets, StoneMarketsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zFAr/BPfrN0I9xCrAp3x84Fx1bDmH28J9sVTTcKism84RgVXG8pKHCBPGmZ7esbj",
  render_errors: [view: StoneMarketsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: StoneMarkets.PubSub,
  live_view: [signing_salt: "GTMXP4TQ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
