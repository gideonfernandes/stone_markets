defmodule StoneMarkets.ErrorTest do
  use StoneMarkets.DataCase, async: true

  alias StoneMarkets.Error

  describe "build/2" do
    test "returns a builded error struct" do
      expected_response = %Error{result: "An error message", status: :bad_request}

      response = Error.build(:bad_request, "An error message")

      assert response === expected_response
    end
  end
end
