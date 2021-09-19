defmodule StoneMarkets.Errors.InvalidCategories do
  alias StoneMarkets.Error

  def call, do: Error.build(:bad_request, "All categories must be valids")
end
