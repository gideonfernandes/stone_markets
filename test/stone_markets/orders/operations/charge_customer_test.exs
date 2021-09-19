defmodule StoneMarkets.Orders.Operations.ChargeCustomerTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.Orders.Operations.ChargeCustomer

  describe "call/1" do
    test "must charge customer and then return the update customer balance" do
      customer_account = insert(:customer_account, balance: 800_000)
      order = insert(:order, customer: customer_account.customer)

      expected_response = {:ok, customer_account.balance - order.total_value}

      response = ChargeCustomer.call(order)

      assert response === expected_response
    end
  end
end
