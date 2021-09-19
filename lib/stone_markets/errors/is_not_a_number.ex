defmodule StoneMarkets.Errors.IsNotANumber do
  @moduledoc """
  This module is responsible for building the IsNotANumber error.
  """

  alias StoneMarkets.Error

  def call, do: Error.build(:not_acceptable, "Value is not a number")
end
