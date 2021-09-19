defmodule StoneMarkets.Marketplaces.IndexTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.Marketplace
  alias StoneMarkets.Marketplaces.Index

  describe "call/0" do
    test "returns all markets" do
      insert_list(2, :marketplace)

      response = Index.call()

      assert {:ok, [%Marketplace{}, %Marketplace{}]} = response
    end
  end
end
