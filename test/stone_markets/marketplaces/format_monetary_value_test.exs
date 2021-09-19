defmodule StoneMarkets.Marketplaces.FormatMonetaryValueTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Arithmetic, BackgroundStorage, Error}
  alias StoneMarkets.Marketplaces.FormatMonetaryValue

  describe "call/1" do
    test "returns the formatted monetary value" do
      customer = insert(:customer)

      BackgroundStorage.storage_signed_customer(customer)

      expected_response = "500,00 USD"

      response =
        500
        |> Arithmetic.cast!(:convert)
        |> Map.get(:value)
        |> FormatMonetaryValue.call()

      assert response === expected_response
    end

    test "returns an error when there are invalid params" do
      customer = insert(:customer)

      BackgroundStorage.storage_signed_customer(customer)

      expected_response = {:error, %Error{result: "Invalid Args", status: :not_acceptable}}

      response = FormatMonetaryValue.call("invalid")

      assert response === expected_response
    end
  end
end
