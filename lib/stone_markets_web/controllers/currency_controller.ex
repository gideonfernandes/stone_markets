defmodule StoneMarketsWeb.CurrencyController do
  @moduledoc """
  This module is responsible for controlling and handling all currency-related
  requests, calling the corresponding business logic module to perform the requested actions.
  """

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
