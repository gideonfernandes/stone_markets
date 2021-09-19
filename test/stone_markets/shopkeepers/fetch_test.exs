defmodule StoneMarkets.Shopkeeper.FetchTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Error, Shopkeeper}
  alias StoneMarkets.Shopkeepers.Fetch

  describe "call/1" do
    test "returns the shopkeeper by the field/value provided" do
      shopkeeper = insert(:shopkeeper)

      response = Fetch.call(shopkeeper.id)

      assert {:ok,
              %Shopkeeper{
                id: _id
              }} = response
    end

    test "returns an error when the shopkeeper is not found" do
      insert(:shopkeeper)

      expected_response = {:error, %Error{result: "Shopkeeper not found", status: :not_found}}

      response = Fetch.call(Ecto.UUID.generate())

      assert response === expected_response
    end
  end
end
