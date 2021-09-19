defmodule StoneMarkets.Marketplaces.Operations.CalculateExchange do
  @moduledoc """
  This module is responsible to fetch the old currency code, prepare incoming value,
  call the exchange module to do the conversion and then return the casted result to caller.
  """

  alias StoneMarkets.{Arithmetic, ExchangeCurrency}

  def call(value, currency_code, old_currency_id) do
    {:ok, old_currency} = StoneMarkets.fetch_currency(old_currency_id)

    casted_value = Arithmetic.cast!(value, :deconvert).value

    {:ok, exchanged} = ExchangeCurrency.call(old_currency.code, currency_code, casted_value)

    Arithmetic.cast!(exchanged, :convert).value
  end
end
