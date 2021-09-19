defmodule StoneMarkets.Currencies.FetchTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Currency, Error}
  alias StoneMarkets.Currencies.Fetch

  describe "call/1" do
    test "returns the currency by the provided ID" do
      currency = insert(:currency)

      response = Fetch.call(currency.id)

      assert {:ok,
              %Currency{
                id: _id
              }} = response
    end

    test "returns an error when the currency is not found" do
      insert(:currency)

      expected_response = {:error, %Error{result: "Currency not found", status: :not_found}}

      response = Fetch.call(Ecto.UUID.generate())

      assert response === expected_response
    end
  end
end
