defmodule StoneMarkets.Product.FetchTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Product, Error}
  alias StoneMarkets.Products.Fetch

  describe "call/1" do
    test "returns the product by the field/value provided" do
      product = insert(:product)

      response = Fetch.call(product.id)

      assert {:ok,
              %Product{
                id: _id
              }} = response
    end

    test "returns an error when the product is not found" do
      insert(:product)

      expected_response = {:error, %Error{result: "Product not found", status: :not_found}}

      response = Fetch.call(Ecto.UUID.generate())

      assert response === expected_response
    end
  end
end
