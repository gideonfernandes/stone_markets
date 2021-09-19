defmodule StoneMarkets.Errors.InvalidArgs do
  @moduledoc """
  This module is responsible for building the InvalidArgs error.
  """

  alias StoneMarkets.Error

  def call, do: Error.build(:not_acceptable, "Invalid Args")
end
