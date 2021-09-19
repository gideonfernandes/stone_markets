defmodule StoneMarkets.Customers.Index do
  alias StoneMarkets.{Customer, Repo}

  def call, do: {:ok, Repo.all(Customer)}
end
