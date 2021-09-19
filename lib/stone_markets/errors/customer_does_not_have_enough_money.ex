defmodule StoneMarkets.Errors.CustomerDoesNotHaveEnoughMoney do
  alias StoneMarkets.Error

  def call, do: Error.build(:bad_request, "Customer does not have enough money")
end
