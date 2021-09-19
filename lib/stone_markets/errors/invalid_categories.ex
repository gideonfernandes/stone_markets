defmodule StoneMarkets.Errors.InvalidCategories do
  @moduledoc """
  This module is responsible for building the InvalidCategories error.
  """

  alias StoneMarkets.Error

  def call, do: Error.build(:bad_request, "All categories must be valids")
end
