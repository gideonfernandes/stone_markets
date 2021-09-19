defmodule StoneMarkets.ProductTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.{Product, Repo}

  describe "changeset/2" do
    test "returns a valid changeset, when all attrs are valid" do
      attrs = build(:product_attrs, %{"name" => "Product test name"})

      response = Product.changeset(attrs)

      assert %Changeset{
               changes: %{
                 name: "Product test name",
                 amount: 5,
                 category: _category,
                 description: "Product description",
                 marketplace_id: _marketplace_id,
                 price: 80_000,
                 shopkeeper_id: _shopkeeper_id
               },
               valid?: true
             } = response
    end

    test "returns an invalid changeset when there are some error" do
      attrs = %{"descripion" => "invalid", "nickname" => "00"}

      response = Product.changeset(attrs)

      expected_response = %{
        amount: ["can't be blank"],
        category: ["can't be blank"],
        description: ["can't be blank"],
        marketplace_id: ["can't be blank"],
        name: ["can't be blank"],
        price: ["can't be blank"],
        shopkeeper_id: ["can't be blank"]
      }

      assert errors_on(response) === expected_response
    end

    test "returns an invalid changeset when amount is not positive" do
      attrs = build(:product_attrs, %{"amount" => 0})

      response =
        attrs
        |> Product.changeset()
        |> Repo.insert()

      assert {:error,
              %Changeset{
                errors: [amount: {"is invalid", _constraint}],
                valid?: false
              }} = response
    end

    test "returns an invalid changeset when price is not positive" do
      attrs = build(:product_attrs, %{"price" => 0})

      response =
        attrs
        |> Product.changeset()
        |> Repo.insert()

      assert {:error,
              %Changeset{
                errors: [price: {"is invalid", _constraint}],
                valid?: false
              }} = response
    end
  end
end
