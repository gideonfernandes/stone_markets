defmodule StoneMarkets.Products.IndexTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{BackgroundStorage, Product}
  alias StoneMarkets.Products.Index

  describe "call/1" do
    setup do
      marketplace = insert(:marketplace)
      customer = insert(:customer, marketplace: marketplace)

      BackgroundStorage.storage_signed_customer(customer)

      {:ok, marketplace: marketplace}
    end

    test "returns all products by marketplace", %{marketplace: marketplace} do
      insert(:product)
      insert(:product, marketplace: marketplace)
      insert(:product, marketplace: marketplace)

      response = Index.call(%{})

      assert {:ok, [%Product{}, %Product{}]} = response
    end

    test "returns all products by marketplace & category", %{marketplace: marketplace} do
      insert(:product, category: :classifieds, marketplace: marketplace)
      insert(:product, category: :electronics, marketplace: marketplace)

      response = Index.call(%{"categories" => "electronics"})

      assert {:ok, [%Product{}]} = response
    end
  end
end
