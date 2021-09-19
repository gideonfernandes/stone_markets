defmodule StoneMarkets.ISO4217Test do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Error, ISO4217}

  describe "call/2" do
    test "returns the formated monetary value to ISO 4217" do
      expected_response = "526,90 BRL"

      currency = insert(:currency, code: "BRL")

      response = ISO4217.call(526.90, currency)

      assert response === expected_response
    end

    test "returns an error when there are invalid params" do
      expected_response = {:error, %Error{result: "Invalid Args", status: :not_acceptable}}

      currency = insert(:currency, code: "BRL")

      response = ISO4217.call("invalid", currency)

      assert response === expected_response
    end
  end
end
