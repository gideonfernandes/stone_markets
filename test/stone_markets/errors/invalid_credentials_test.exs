defmodule StoneMarkets.Errors.InvalidCredentialsTest do
  use StoneMarkets.DataCase, async: true

  alias StoneMarkets.Error
  alias StoneMarkets.Errors.InvalidCredentials

  describe "call/0" do
    test "returns a InvalidCredentials builded error" do
      expected_response = %Error{result: "Please verify your credentials", status: :unauthorized}

      response = InvalidCredentials.call()

      assert response === expected_response
    end
  end
end
