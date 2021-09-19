defmodule StoneMarkets.Customers.Index do
  alias StoneMarkets.{Repo, Customer}

  def call, do: {:ok, Repo.all(Customer)}
end
