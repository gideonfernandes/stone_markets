defmodule StoneMarkets.Errors.CurrencyProvidedIsAlreadyCurrent do
  alias StoneMarkets.Error

  def call, do: Error.build(:bad_request, "Currency provided is already current")
end
