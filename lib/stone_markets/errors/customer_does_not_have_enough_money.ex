defmodule StoneMarkets.Errors.CustomerDoesNotHaveEnoughMoney do
  @moduledoc """
  This module is responsible for building the CustomerDoesNotHaveEnoughMoney error.
  """

  alias StoneMarkets.Error

  def call, do: Error.build(:bad_request, "Customer does not have enough money")
end
