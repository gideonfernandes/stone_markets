defmodule StoneMarkets.Marketplaces.Import do
  @moduledoc """
  This module is responsable for imports all marketplaces from json fixture file.
  """

  def call do
    with {:ok, brl} <- fetch_brl_currency(),
         {:ok, eur} <- fetch_eur_currency(),
         {:ok, usd} <- fetch_usd_currency(),
         {:ok, markets_content} <- read_markets(),
         {:ok, %{"markets" => markets}} <- Jason.decode(markets_content) do
      {brl_market, eur_market, usd_market} = List.to_tuple(markets)

      insert_market(brl_market, brl)
      insert_market(eur_market, eur)
      insert_market(usd_market, usd)
    else
      _ -> "An error occurred creating the markets..."
    end
  end

  def fetch_brl_currency, do: fetch_currency("BRL")
  def fetch_eur_currency, do: fetch_currency("EUR")
  def fetch_usd_currency, do: fetch_currency("USD")
  defp fetch_currency(code), do: StoneMarkets.fetch_currency_by(:code, code)
  defp read_markets, do: File.read("priv/repo/seeds/fixtures/markets.json")

  defp insert_market(market, currency) do
    market
    |> Map.put("default_currency_id", currency.id)
    |> StoneMarkets.create_marketplace()
  end
end
