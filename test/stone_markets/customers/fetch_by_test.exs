defmodule StoneMarkets.Customer.FetchByTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Customer, Error}
  alias StoneMarkets.Customers.FetchBy

  describe "call/2" do
    test "returns the customer by the field/value provided" do
      insert(:customer, name: "test_customer")

      response = FetchBy.call(:name, "test_customer")

      assert {:ok,
              %Customer{
                id: _id,
                name: "test_customer"
              }} = response
    end

    test "returns an error when the customer is not found" do
      insert(:customer, name: "test_customer")

      expected_response = {:error, %Error{result: "Customer not found", status: :not_found}}

      response = FetchBy.call(:name, "invalid_test_customer")

      assert response === expected_response
    end
  end
end
