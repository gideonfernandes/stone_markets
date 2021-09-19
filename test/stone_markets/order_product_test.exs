defmodule StoneMarkets.OrderProductTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.OrderProduct

  describe "changeset/2" do
    test "returns a valid changeset, when all attrs are valid" do
      attrs = %{"order_id" => Ecto.UUID.generate(), "product_id" => Ecto.UUID.generate()}

      response = OrderProduct.changeset(attrs)

      assert %Changeset{
               changes: %{
                 order_id: _order_id,
                 product_id: _product_id
               },
               valid?: true
             } = response
    end

    test "returns an invalid changeset when there are some error" do
      attrs = %{}

      response = OrderProduct.changeset(attrs)

      expected_response = %{order_id: ["can't be blank"], product_id: ["can't be blank"]}

      assert errors_on(response) === expected_response
    end

    test "returns an invalid changeset when there is impersisted order" do
      attrs = %{"order_id" => Ecto.UUID.generate(), "product_id" => insert(:product).id}

      response =
        attrs
        |> OrderProduct.changeset()
        |> Repo.insert()

      assert {:error,
              %Changeset{
                errors: [order_id: {"does not exist", _constraint}],
                valid?: false
              }} = response
    end

    test "returns an invalid changeset when there is impersisted product" do
      attrs = %{"order_id" => insert(:order).id, "product_id" => Ecto.UUID.generate()}

      response =
        attrs
        |> OrderProduct.changeset()
        |> Repo.insert()

      assert {:error,
              %Changeset{
                errors: [product_id: {"does not exist", _constraint}],
                valid?: false
              }} = response
    end
  end
end
