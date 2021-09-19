defmodule StoneMarkets.Errors.IsRequired do
  alias StoneMarkets.Error

  def call(resource_name), do: Error.build(:bad_request, "#{resource_name} is required")
end
