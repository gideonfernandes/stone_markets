defmodule StoneMarkets.ExchangerateApi.Client do
  @moduledoc """
  This module is responsible for fetch currency exchange value informations
  provided by the ExchangerateAPI.
  """

  use Tesla

  alias StoneMarkets.{BackgroundStorage, FallbackError}
  alias StoneMarkets.Errors.ResourceNotFound
  alias Tesla.Env

  @behaviour StoneMarkets.ExchangerateApi.Behaviour
  @base_url "https://v6.exchangerate-api.com/v6/a453c395ac18a6e18c71ae2c/latest/"

  plug(Tesla.Middleware.JSON)

  def call(url \\ @base_url, currency_code) when is_bitstring(currency_code) do
    case get("#{url}#{currency_code}") do
      {:ok, %Env{status: 200, body: body}} -> storage_currency(currency_code, body)
      {:ok, %Env{status: 404, body: _body}} -> ResourceNotFound.call("Currency")
      error -> FallbackError.call(error)
    end
  end

  defp storage_currency(currency_code, body) do
    rates = Map.get(body, "conversion_rates")
    BackgroundStorage.storage_currency_conversion_rates(currency_code, rates)

    {:ok, rates}
  end
end
