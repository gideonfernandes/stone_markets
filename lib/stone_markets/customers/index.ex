defmodule StoneMarkets.Customers.Index do
  @moduledoc """
  This module is responsible for fetch all customers.
  """

  alias StoneMarkets.{Customer, Repo}

  def call, do: {:ok, Repo.all(Customer)}
end
