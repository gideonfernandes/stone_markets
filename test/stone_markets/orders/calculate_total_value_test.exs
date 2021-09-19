defmodule StoneMarkets.Orders.CalculateTotalValueTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.Orders.CalculateTotalValue

  describe "call/1" do
    test "returns the order total price" do
      [product1, product2] = insert_list(2, :product)

      expected_response = {:ok, 160_000}

      response = CalculateTotalValue.call([product1, product2])

      assert response === expected_response
    end
  end
end
