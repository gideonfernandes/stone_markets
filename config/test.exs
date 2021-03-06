use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :stone_markets, StoneMarkets.Repo,
  username: "postgres",
  password: "postgres",
  database: "stone_markets_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stone_markets, StoneMarketsWeb.Endpoint,
  http: [port: 4002],
  server: false

config :stone_markets, StoneMarkets.ExchangeCurrency,
  exchangerate_api_adapter: StoneMarkets.ExchangerateApi.ClientMock

# Print only warnings and errors during test
config :logger, level: :warn
