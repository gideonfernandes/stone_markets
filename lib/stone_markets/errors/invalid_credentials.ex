defmodule StoneMarkets.Errors.InvalidCredentials do
  @moduledoc """
  This module is responsible for building the InvalidCredentials error.
  """

  alias StoneMarkets.Error

  def call, do: Error.build(:unauthorized, "Please verify your credentials")
end
