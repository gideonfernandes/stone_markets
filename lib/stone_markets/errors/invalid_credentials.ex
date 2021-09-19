defmodule StoneMarkets.Errors.InvalidCredentials do
  alias StoneMarkets.Error

  def call, do: Error.build(:unauthorized, "Please verify your credentials")
end
