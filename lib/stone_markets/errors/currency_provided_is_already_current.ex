defmodule StoneMarkets.Errors.CurrencyCodeIsRequired do
  alias StoneMarkets.Error

  def call, do: Error.build(:bad_request, "Currency code is required")
end
