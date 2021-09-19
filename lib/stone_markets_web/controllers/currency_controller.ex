defmodule StoneMarketsWeb.CurrencyController do
  @moduledoc """
  This module is responsible for controlling and handling all currency-related
  requests, calling the corresponding business logic module to perform the requested actions.
  """

  use StoneMarketsWeb, :controller

  alias StoneMarkets.Errors.InvalidArgs
  alias StoneMarkets.ExchangeCurrency
  alias StoneMarketsWeb.FallbackController

  action_fallback FallbackController

  def index(conn, _params) do
    with {:ok, currencies} <- StoneMarkets.currencies() do
      conn
      |> put_status(:ok)
      |> render("index.json", currencies: currencies)
    end
  end

  def exchange(conn, %{"from_code" => from_code, "to_code" => to_code, "value" => value}) do
    with {:ok, result} <- ExchangeCurrency.call(from_code, to_code, value),
         {:ok, currency} <- StoneMarkets.fetch_currency_by(:code, to_code) do
      conn
      |> put_status(:ok)
      |> json(%{
        from_code: from_code,
        to_code: to_code,
        value: value,
        result: StoneMarkets.format_to_iso_4217(result, currency),
        message: "Exchange performed successfully!"
      })
    end
  end

  def exchange(_conn, _params), do: {:error, InvalidArgs.call()}
end
