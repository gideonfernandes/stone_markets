defmodule StoneMarkets.Customers.Fetch do
  alias StoneMarkets.{Customer, FallbackError, Repo}
  alias StoneMarkets.Errors.ResourceNotFound

  def call(id) do
    with %Customer{} = customer <- Repo.get(Customer, id),
         %Customer{} = customer_with_account <- Repo.preload(customer, :account) do
      {:ok, customer_with_account}
    else
      nil -> {:error, ResourceNotFound.call("Customer")}
      error -> FallbackError.call(error)
    end
  end
end
