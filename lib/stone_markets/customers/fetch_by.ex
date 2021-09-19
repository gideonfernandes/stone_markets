defmodule StoneMarkets.Customers.FetchBy do
  @moduledoc """
  This module is responsible for fetch an customer by the provided attribute.
  """

  alias StoneMarkets.{Customer, FallbackError, Repo}
  alias StoneMarkets.Errors.ResourceNotFound

  def call(field, value) do
    key_value = Map.new([field], fn field -> {field, value} end)

    with %Customer{} = customer <- Repo.get_by(Customer, key_value),
         %Customer{} = customer_with_account <- Repo.preload(customer, :account) do
      {:ok, customer_with_account}
    else
      nil -> {:error, ResourceNotFound.call("Customer")}
      error -> FallbackError.call(error)
    end
  end
end
