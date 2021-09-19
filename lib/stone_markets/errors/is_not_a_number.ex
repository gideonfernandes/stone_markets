defmodule StoneMarkets.Errors.IsNotANumber do
  alias StoneMarkets.Error

  def call, do: Error.build(:not_acceptable, "Value is not a number")
end
