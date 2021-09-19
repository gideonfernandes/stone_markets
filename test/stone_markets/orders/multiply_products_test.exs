defmodule StoneMarkets.Orders.MultiplyProductsTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.Product
  alias StoneMarkets.Orders.MultiplyProducts

  describe "call/1" do
    test "returns multiplied products when all product params are valid" do
      [product1, product2] = insert_list(2, :product)

      products = [
        %{"id" => product1.id, "amount" => 2},
        %{"id" => product2.id, "amount" => 1}
      ]

      response = MultiplyProducts.call(products)

      assert {:ok,
              [
                %Product{
                  amount: 5,
                  category: _,
                  description: "Product description",
                  id: _,
                  marketplace_id: _,
                  name: _,
                  price: 80000,
                  shopkeeper_id: _
                },
                %Product{
                  amount: 5,
                  category: _,
                  description: "Product description",
                  id: _,
                  marketplace_id: _,
                  name: _,
                  price: 80000,
                  shopkeeper_id: _
                },
                %Product{
                  amount: 5,
                  category: _,
                  description: "Product description",
                  id: _,
                  marketplace_id: _,
                  name: _,
                  price: 80000,
                  shopkeeper_id: _
                }
              ]} = response
    end
  end
end
