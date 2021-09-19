defmodule StoneMarkets.Marketplaces.FormatMonetaryValue do
  @moduledoc """
  This module is responsible for formatting an incoming number into a monetary string,
  considering the current currency of the market linked to the signed customer.
  It memorizes the last currency fetched by the signed customer to avoid unnecessary queries.
  """

  use Memoize
  alias StoneMarkets.{Arithmetic, BackgroundStorage, Repo}
  alias StoneMarkets.Errors.InvalidArgs
  alias StoneMarkets.ISO4217

  def call(value) when is_number(value) do
    ISO4217.call(Arithmetic.cast!(value, :deconvert).value, current_market_currency())
  end

  def call(_), do: {:error, InvalidArgs.call()}

  defmemo current_market_currency do
    customer =
      BackgroundStorage.fetch_signed_customer()
      |> Repo.preload(marketplace: :default_currency)

    customer.marketplace.default_currency
  end
end
