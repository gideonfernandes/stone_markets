defmodule StoneMarkets.Orders.CreateTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.{Account, Error, Order, Product, Repo}
  alias StoneMarkets.Orders.Create

  describe "call/1" do
    setup do
      order_attrs = build(:order_attrs)

      {:ok, attrs: order_attrs.params}
    end

    test "creates the order", %{attrs: attrs} do
      customer_id = attrs["customer_id"]
      marketplace_id = attrs["marketplace_id"]

      response = Create.call(attrs)

      assert {
               :ok,
               %Order{
                 address: "Rua dos macarrões",
                 comments: "Um comentário qualquer",
                 customer_id: ^customer_id,
                 id: _id,
                 marketplace_id: ^marketplace_id,
                 products: [%Product{}],
                 total_value: 80_000
               }
             } = response
    end

    test "returns an error when the customer does not have enough money", %{attrs: attrs} do
      customer_id = attrs["customer_id"]

      Repo.get_by!(Account, customer_id: customer_id)
      |> Changeset.change(balance: 0)
      |> Repo.update()

      expected_response =
        {:error,
         %StoneMarkets.Error{
           result: "Customer does not have enough money",
           status: :bad_request
         }}

      response = Create.call(attrs)

      assert response === expected_response
    end

    test "returns invalid changeset when there are some invalid params" do
      expected_response = %{
        marketplace_id: ["can't be blank"],
        address: ["can't be blank"],
        customer_id: ["can't be blank"],
        products: ["can't be blank"]
      }

      {:error, %Error{result: response}} = Create.call(%{})

      assert errors_on(response) === expected_response
    end
  end
end
