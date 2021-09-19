defmodule StoneMarkets.Errors.InvalidCategoriesTest do
  use StoneMarkets.DataCase, async: true

  alias StoneMarkets.Error
  alias StoneMarkets.Errors.InvalidCategories

  describe "call/0" do
    test "returns a InvalidCategories builded error" do
      expected_response = %Error{result: "All categories must be valids", status: :bad_request}

      response = InvalidCategories.call()

      assert response === expected_response
    end
  end
end
