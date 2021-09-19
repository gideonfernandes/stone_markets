defmodule StoneMarkets.Customers.IndexTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.Customer
  alias StoneMarkets.Customers.Index

  describe "call/1" do
    test "returns all customers" do
      insert(:customer)
      insert(:customer, cpf: "11111111111")

      response = Index.call()

      assert {:ok, [%Customer{}, %Customer{}]} = response
    end
  end
end
