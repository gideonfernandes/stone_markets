defmodule StoneMarkets.Errors.CurrencyProvidedIsAlreadyCurrentTest do
  use StoneMarkets.DataCase, async: true

  alias StoneMarkets.Error
  alias StoneMarkets.Errors.CurrencyProvidedIsAlreadyCurrent

  describe "call/0" do
    test "returns a CurrencyProvidedIsAlreadyCurrent builded error" do
      expected_response = %Error{
        result: "Currency provided is already current",
        status: :bad_request
      }

      response = CurrencyProvidedIsAlreadyCurrent.call()

      assert response === expected_response
    end
  end
end
