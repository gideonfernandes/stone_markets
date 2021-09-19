defmodule StoneMarkets.Marketplaces.Operations.CalculateExchange do
  alias StoneMarkets.{Arithmetic, ExchangeCurrency}

  def call(value, currency_code, old_currency_id) do
    {:ok, old_currency} = StoneMarkets.fetch_currency(old_currency_id)

    casted_value = Arithmetic.cast!(value, :deconvert).value

    {:ok, exchanged} = ExchangeCurrency.call(old_currency.code, currency_code, casted_value)

    Arithmetic.cast!(exchanged, :convert).value
  end
end
