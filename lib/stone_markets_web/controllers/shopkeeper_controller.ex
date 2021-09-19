defmodule StoneMarketsWeb.ShopkeeperController do
  use StoneMarketsWeb, :controller

  alias StoneMarkets.Shopkeeper
  alias StoneMarketsWeb.FallbackController

  action_fallback FallbackController

  def index(conn, params) do
    with {:ok, shopkeepers} <- StoneMarkets.shopkeepers(params) do
      conn
      |> put_status(:ok)
      |> render("index.json", shopkeepers: shopkeepers)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Shopkeeper{} = shopkeeper} <- StoneMarkets.fetch_shopkeeper(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", shopkeeper: shopkeeper)
    end
  end
end
