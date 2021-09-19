defmodule StoneMarkets.Customer.FetchTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Customer, Error}
  alias StoneMarkets.Customers.Fetch

  describe "call/1" do
    test "returns the customer by the provided ID" do
      customer = insert(:customer)

      response = Fetch.call(customer.id)

      assert {:ok,
              %Customer{
                id: _id
              }} = response
    end

    test "returns an error when the customer is not found" do
      insert(:customer)

      expected_response = {:error, %Error{result: "Customer not found", status: :not_found}}

      response = Fetch.call(Ecto.UUID.generate())

      assert response === expected_response
    end
  end
end
