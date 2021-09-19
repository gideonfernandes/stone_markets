defmodule StoneMarketsWeb.CurrencyController do
  use StoneMarketsWeb, :controller

  alias StoneMarketsWeb.FallbackController

  action_fallback FallbackController

  def index(conn, _params) do
    with {:ok, currencies} <- StoneMarkets.currencies() do
      conn
      |> put_status(:ok)
      |> render("index.json", currencies: currencies)
    end
  end
end
