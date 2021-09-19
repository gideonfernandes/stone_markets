defmodule StoneMarkets.Errors.CurrencyCodeIsRequiredTest do
  use StoneMarkets.DataCase, async: true

  alias StoneMarkets.Error
  alias StoneMarkets.Errors.CurrencyCodeIsRequired

  describe "call/0" do
    test "returns a CurrencyCodeIsRequired builded error" do
      expected_response = %Error{result: "Currency code is required", status: :bad_request}

      response = CurrencyCodeIsRequired.call()

      assert response === expected_response
    end
  end
end
