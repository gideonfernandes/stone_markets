ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(StoneMarkets.Repo, :manual)

# Mock modules
Mox.defmock(StoneMarkets.ExchangerateApi.ClientMock, for: StoneMarkets.ExchangerateApi.Behaviour)
