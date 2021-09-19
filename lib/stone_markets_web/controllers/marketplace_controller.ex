defmodule StoneMarketsWeb.MarketplaceController do
  use StoneMarketsWeb, :controller

  alias StoneMarkets.Marketplace
  alias StoneMarketsWeb.FallbackController

  action_fallback(FallbackController)

  def index(conn, _params) do
    with {:ok, marketplaces} <- StoneMarkets.marketplaces() do
      conn
      |> put_status(:ok)
      |> render("index.json", marketplaces: marketplaces)
    end
  end

  def update(conn, params) do
    with {:ok, %Marketplace{} = marketplace, old_currency_id: old_currency_id} <-
           StoneMarkets.update_marketplace(params) do
      GenServer.cast(CurrencyUpdateWorker, {:convert_currencies, marketplace, old_currency_id})

      conn
      |> put_status(:ok)
      |> render("show.json", marketplace: marketplace)
    end
  end
end
