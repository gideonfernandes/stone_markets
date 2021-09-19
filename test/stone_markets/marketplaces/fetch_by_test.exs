defmodule StoneMarkets.Marketplaces.FetchByTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Error, Marketplace}
  alias StoneMarkets.Marketplaces.FetchBy

  describe "call/2" do
    test "returns the market by the field/value provided" do
      insert(:marketplace, name: "test_market")

      response = FetchBy.call(:name, "test_market")

      assert {:ok,
              %Marketplace{
                id: _id,
                name: "test_market"
              }} = response
    end

    test "returns an error when the market is not found" do
      insert(:marketplace, name: "test_market")

      expected_response = {:error, %Error{result: "Marketplace not found", status: :not_found}}

      response = FetchBy.call(:name, "invalid_test_market")

      assert response === expected_response
    end
  end
end
