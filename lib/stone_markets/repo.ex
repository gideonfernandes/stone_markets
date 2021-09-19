defmodule StoneMarkets.Repo do
  use Ecto.Repo,
    otp_app: :stone_markets,
    adapter: Ecto.Adapters.Postgres
end
