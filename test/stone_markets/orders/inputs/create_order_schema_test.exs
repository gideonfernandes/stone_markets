defmodule StoneMarkets.Orders.Inputs.CreateOrderSchemaTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.Orders.Inputs.CreateOrderSchema

  describe "changeset/2" do
    setup do
      order = build(:order_attrs)

      {:ok, attrs: order.params, marketplace: order.marketplace}
    end

    test "returns a valid changeset, when all attrs are valid", %{attrs: attrs} do
      response = CreateOrderSchema.changeset(attrs)

      assert %Changeset{
               changes: %{
                 address: "Rua dos macarrões",
                 customer_id: _customer_id,
                 marketplace_id: _marketplace_id
               },
               errors: [],
               valid?: true
             } = response
    end

    test "returns an invalid changeset when there are invalid product ids", %{attrs: attrs} do
      [product] = attrs["products"]

      attrs = Map.put(attrs, "products", [Map.put(product, "id", "invalid")])

      response = CreateOrderSchema.changeset(attrs)

      expected_response = %{products: ["All product IDs must be valid"]}

      assert errors_on(response) === expected_response
    end

    test "returns an invalid changeset when there is insufficient product' amounts", %{
      attrs: attrs,
      marketplace: marketplace
    } do
      [product] = attrs["products"]

      attrs =
        Map.put(attrs, "products", [
          product,
          %{
            "id" => insert(:product, marketplace: marketplace).id,
            "amount" => 10
          }
        ])

      response = CreateOrderSchema.changeset(attrs)

      expected_response = %{products: ["Some products do not have enough amount"]}

      assert errors_on(response) === expected_response
    end

    test "returns an invalid changeset when some product is not found", %{attrs: attrs} do
      [product] = attrs["products"]

      attrs = Map.put(attrs, "products", [Map.put(product, "id", Ecto.UUID.generate())])

      response = CreateOrderSchema.changeset(attrs)

      expected_response = %{products: ["Some products were not found"]}

      assert errors_on(response) === expected_response
    end
  end
end
