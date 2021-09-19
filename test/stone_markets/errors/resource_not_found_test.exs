defmodule StoneMarkets.Errors.ResourceNotFoundTest do
  use StoneMarkets.DataCase, async: true

  alias StoneMarkets.Error
  alias StoneMarkets.Errors.ResourceNotFound

  describe "call/1" do
    test "returns a ResourceNotFound builded error" do
      expected_response = %Error{result: "Resource Name not found", status: :not_found}

      response = ResourceNotFound.call("Resource Name")

      assert response === expected_response
    end
  end
end
