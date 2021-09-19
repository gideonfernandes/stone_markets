defmodule StoneMarkets.Orders.Operations.SplitPaymentsTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Account, Repo}
  alias StoneMarkets.Orders.Operations.SplitPayments

  describe "call/1" do
    setup do
      marketplace = insert(:marketplace)

      customer_id =
        insert(:customer_account, customer: insert(:customer, marketplace: marketplace)).customer_id

      shopkeeper1 = insert(:shopkeeper)
      shopkeeper2 = insert(:shopkeeper)
      shopkeeper3 = insert(:shopkeeper)

      insert(:shopkeeper_account,
        balance: 10_000,
        marketplace: marketplace,
        shopkeeper: shopkeeper1
      )

      insert(:shopkeeper_account,
        balance: 10_000,
        marketplace: marketplace,
        shopkeeper: shopkeeper2
      )

      insert(:shopkeeper_account,
        balance: 10_000,
        marketplace: marketplace,
        shopkeeper: shopkeeper3
      )

      shopkeeper_1_product1 =
        insert(:product,
          amount: 20,
          price: 1000,
          marketplace: marketplace,
          shopkeeper: shopkeeper1
        )

      shopkeeper_1_product2 =
        insert(:product,
          amount: 20,
          price: 1000,
          marketplace: marketplace,
          shopkeeper: shopkeeper1
        )

      shopkeeper_1_product3 =
        insert(:product,
          amount: 20,
          price: 1000,
          marketplace: marketplace,
          shopkeeper: shopkeeper1
        )

      shopkeeper_2_product1 =
        insert(:product,
          amount: 20,
          price: 1000,
          marketplace: marketplace,
          shopkeeper: shopkeeper2
        )

      shopkeeper_2_product2 =
        insert(:product,
          amount: 20,
          price: 1000,
          marketplace: marketplace,
          shopkeeper: shopkeeper2
        )

      shopkeeper_3_product1 =
        insert(:product,
          amount: 20,
          price: 1000,
          marketplace: marketplace,
          shopkeeper: shopkeeper3
        )

      attrs = %{
        "marketplace_id" => marketplace.id,
        "customer_id" => customer_id,
        "address" => "Rua dos macarrões",
        "products" => [
          %{
            "id" => shopkeeper_1_product1.id,
            "amount" => 10
          },
          %{
            "id" => shopkeeper_1_product2.id,
            "amount" => 5
          },
          %{
            "id" => shopkeeper_1_product3.id,
            "amount" => 1
          },
          %{
            "id" => shopkeeper_2_product1.id,
            "amount" => 5
          },
          %{
            "id" => shopkeeper_2_product2.id,
            "amount" => 5
          },
          %{
            "id" => shopkeeper_3_product1.id,
            "amount" => 20
          }
        ]
      }

      {:ok, order} = StoneMarkets.create_order(attrs)

      {:ok,
       order: order, shopkeeper1: shopkeeper1, shopkeepere: shopkeeper2, shopkeeper3: shopkeeper3}
    end

    test "must split order payments to corresponding shopkeepers", %{
      order: order,
      shopkeeper1: shopkeeper1,
      shopkeepere: shopkeeper2,
      shopkeeper3: shopkeeper3
    } do
      expected_response = {26_000, 20_000, 30_000}

      SplitPayments.call(order)

      response =
        {Repo.get_by!(Account, shopkeeper_id: shopkeeper1.id).balance,
         Repo.get_by!(Account, shopkeeper_id: shopkeeper2.id).balance,
         Repo.get_by!(Account, shopkeeper_id: shopkeeper3.id).balance}

      assert response === expected_response
    end
  end
end
