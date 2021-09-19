defmodule StoneMarkets.Errors.ResourceNotFound do
  alias StoneMarkets.Error

  def call(resource_name), do: Error.build(:not_found, "#{resource_name} not found")
end
