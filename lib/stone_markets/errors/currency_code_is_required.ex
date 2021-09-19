defmodule StoneMarkets.Errors.CurrencyProvidedIsAlreadyCurrent do
  @moduledoc """
  This module is responsible for building the CurrencyProvidedIsAlreadyCurrent error.
  """

  alias StoneMarkets.Error

  def call, do: Error.build(:bad_request, "Currency provided is already current")
end
