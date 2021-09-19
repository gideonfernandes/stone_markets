defmodule StoneMarkets.Errors.IsRequired do
  @moduledoc """
  This module is responsible for building the IsRequired error.
  """

  alias StoneMarkets.Error

  def call(resource_name), do: Error.build(:bad_request, "#{resource_name} is required")
end
