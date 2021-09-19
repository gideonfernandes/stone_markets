defmodule StoneMarkets.Currencies.FetchByTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Currency, Error}
  alias StoneMarkets.Currencies.FetchBy

  describe "call/2" do
    test "returns the currency by the field/value provided" do
      insert(:currency, name: "test_currency")

      response = FetchBy.call(:name, "test_currency")

      assert {:ok,
              %Currency{
                id: _id,
                name: "test_currency"
              }} = response
    end

    test "returns an error when the currency is not found" do
      insert(:currency, name: "test_currency")

      expected_response = {:error, %Error{result: "Currency not found", status: :not_found}}

      response = FetchBy.call(:name, "invalid_test_currency")

      assert response === expected_response
    end
  end
end
