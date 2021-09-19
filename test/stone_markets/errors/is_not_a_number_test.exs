defmodule StoneMarkets.Errors.IsNotANumberTest do
  use StoneMarkets.DataCase, async: true

  alias StoneMarkets.Error
  alias StoneMarkets.Errors.IsNotANumber

  describe "call/0" do
    test "returns a IsNotANumber builded error" do
      expected_response = %Error{result: "Value is not a number", status: :not_acceptable}

      response = IsNotANumber.call()

      assert response === expected_response
    end
  end
end
