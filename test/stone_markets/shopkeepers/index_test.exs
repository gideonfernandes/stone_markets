defmodule StoneMarkets.Shopkeepers.IndexTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{BackgroundStorage, Shopkeeper}
  alias StoneMarkets.Shopkeepers.Index

  describe "call/1" do
    setup do
      marketplace = insert(:marketplace)
      customer = insert(:customer, marketplace: marketplace)

      BackgroundStorage.storage_signed_customer(customer)

      {:ok, marketplace: marketplace}
    end

    test "returns all shopkeepers by marketplace", %{marketplace: marketplace} do
      insert(:shopkeeper)
      insert(:shopkeeper, marketplace: marketplace)
      insert(:shopkeeper, marketplace: marketplace)

      response = Index.call(%{})

      assert {:ok, [%Shopkeeper{}, %Shopkeeper{}]} = response
    end

    test "returns all shopkeepers by category & marketplace", %{marketplace: marketplace} do
      insert(:shopkeeper, category: :classifieds, marketplace: marketplace)
      insert(:shopkeeper, category: :electronics, marketplace: marketplace)

      response = Index.call(%{"categories" => "electronics"})

      assert {:ok, [%Shopkeeper{}]} = response
    end
  end
end
