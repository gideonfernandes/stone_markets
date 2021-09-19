defmodule StoneMarkets.OrderTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.{Order, Repo}

  describe "changeset/2" do
    setup do
      order = build(:order_attrs)

      {:ok, attrs: order.params, products: order.products}
    end

    test "returns a valid changeset, when all attrs are valid", %{
      attrs: attrs,
      products: products
    } do
      response = Order.changeset(attrs, products)

      assert %Changeset{
               changes: %{
                 marketplace_id: _marketplace_id,
                 address: "Rua dos macarrões",
                 comments: "Um comentário qualquer",
                 customer_id: _customer_id,
                 products: [_product],
                 total_value: 80_000
               },
               valid?: true
             } = response
    end

    test "returns an invalid changeset, marketplace is not found", %{
      attrs: attrs,
      products: products
    } do
      attrs = Map.put(attrs, "marketplace_id", Ecto.UUID.generate())

      response =
        Order.changeset(attrs, products)
        |> Repo.insert()

      assert {:error,
              %Changeset{
                errors: [marketplace_id: {"does not exist", _constraint}],
                valid?: false
              }} = response
    end

    test "returns an invalid changeset, customer is not found", %{
      attrs: attrs,
      products: products
    } do
      attrs = Map.put(attrs, "customer_id", Ecto.UUID.generate())

      response =
        Order.changeset(attrs, products)
        |> Repo.insert()

      assert {:error,
              %Changeset{
                errors: [customer_id: {"does not exist", _constraint}],
                valid?: false
              }} = response
    end

    test "returns an invalid changeset when there are some error" do
      response = Order.changeset(%{}, [])

      expected_response = %{
        address: ["can't be blank"],
        customer_id: ["can't be blank"],
        marketplace_id: ["can't be blank"],
        total_value: ["can't be blank"]
      }

      assert errors_on(response) === expected_response
    end
  end
end
