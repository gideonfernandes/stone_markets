defmodule StoneMarkets.Errors.InvalidArgs do
  alias StoneMarkets.Error

  def call, do: Error.build(:not_acceptable, "Invalid Args")
end
