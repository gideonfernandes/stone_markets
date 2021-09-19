defmodule StoneMarkets.Orders.CheckCustomerPurchasingPowerTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Account, Error}
  alias StoneMarkets.Orders.CheckCustomerPurchasingPower

  describe "call/2" do
    test "returns customer_id when customer has enough money" do
      %Account{customer_id: customer_id} = insert(:customer_account, balance: 10_000_000)

      expected_response = {:ok, customer_id}

      response = CheckCustomerPurchasingPower.call(customer_id, 10_000_000)

      assert response === expected_response
    end

    test "returns an error when customer has no enough money" do
      %Account{customer_id: customer_id} = insert(:customer_account, balance: 10_000_000)

      expected_response =
        {:error, %Error{result: "Customer does not have enough money", status: :bad_request}}

      response = CheckCustomerPurchasingPower.call(customer_id, 10_000_001)

      assert response === expected_response
    end
  end
end
