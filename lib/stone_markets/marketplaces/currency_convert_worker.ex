defmodule StoneMarkets.Marketplaces.CurrencyConvertWorker do
  use GenServer

  require Logger

  alias StoneMarkets.Repo
  alias StoneMarkets.Marketplaces.FormatMonetaryValue

  alias StoneMarkets.Marketplaces.Operations.{
    ConvertAccountBalances,
    ConvertOrderTotalValues,
    ConvertProductPrices
  }

  def start_link(_initial_state) do
    GenServer.start_link(__MODULE__, %{}, name: CurrencyConvertWorker)
  end

  @impl true
  def init(state) do
    Logger.info("Currency Convert Worker started!")

    {:ok, state}
  end

  @impl true
  def handle_cast({:convert_currencies, marketplace, old_currency_id}, state) do
    Logger.info("Executing monetary updation, Marketplace ID: #{marketplace.id}")

    convert_currencies_transaction(marketplace, old_currency_id)

    Memoize.invalidate(FormatMonetaryValue, :current_market_currency)

    {:noreply, state}
  end

  defp convert_currencies_transaction(marketplace, old_currency_id) do
    marketplace = Repo.preload(marketplace, :default_currency)

    Repo.transaction(fn ->
      ConvertAccountBalances.call({marketplace, old_currency_id})
      ConvertOrderTotalValues.call({marketplace, old_currency_id})
      ConvertProductPrices.call({marketplace, old_currency_id})
    end)
  end
end
