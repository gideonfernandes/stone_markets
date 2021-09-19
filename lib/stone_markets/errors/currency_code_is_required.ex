defmodule Testing.Errors.CurrencyProvidedIsAlreadyCurrent do
  alias Testing.Error

  def call, do: Error.build(:bad_request, "Currency provided is already current")
end
