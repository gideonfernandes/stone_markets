defmodule StoneMarkets.Errors.CustomerDoesNotHaveEnoughMoneyTest do
  use StoneMarkets.DataCase, async: true

  alias StoneMarkets.Error
  alias StoneMarkets.Errors.CustomerDoesNotHaveEnoughMoney

  describe "call/0" do
    test "returns a CustomerDoesNotHaveEnoughMoney builded error" do
      expected_response = %Error{
        result: "Customer does not have enough money",
        status: :bad_request
      }

      response = CustomerDoesNotHaveEnoughMoney.call()

      assert response === expected_response
    end
  end
end
