defmodule StoneMarkets.Errors.InvalidArgsTest do
  use StoneMarkets.DataCase, async: true

  alias StoneMarkets.Error
  alias StoneMarkets.Errors.InvalidArgs

  describe "call/0" do
    test "returns a InvalidArgs builded error" do
      expected_response = %Error{result: "Invalid Args", status: :not_acceptable}

      response = InvalidArgs.call()

      assert response === expected_response
    end
  end
end
