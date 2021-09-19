defmodule StoneMarkets.Errors.CurrencyCodeIsRequired do
  @moduledoc """
  This module is responsible for building the CurrencyCodeIsRequired error.
  """

  alias StoneMarkets.Error

  def call, do: Error.build(:bad_request, "Currency code is required")
end
