defmodule StoneMarkets.Errors.ResourceNotFound do
  @moduledoc """
  This module is responsible for building the ResourceNotFound error.
  """

  alias StoneMarkets.Error

  def call(resource_name), do: Error.build(:not_found, "#{resource_name} not found")
end
