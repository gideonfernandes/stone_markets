defmodule StoneMarkets.Currencies.IndexTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.Currency
  alias StoneMarkets.Currencies.Index

  describe "call/1" do
    test "returns all currencies" do
      insert_list(2, :currency)

      response = Index.call()

      assert {:ok, [%Currency{}, %Currency{}]} = response
    end
  end
end
