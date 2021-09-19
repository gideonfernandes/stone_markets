defmodule StoneMarkets.Marketplaces.Operations.ConvertProductPricesTest do
  use StoneMarkets.DataCase, async: true

  import Mox
  import StoneMarkets.Factory

  alias StoneMarkets.{Arithmetic, Product}
  alias StoneMarkets.ExchangerateApi.ClientMock
  alias StoneMarkets.Marketplaces.Operations.ConvertProductPrices

  describe "call/1" do
    setup do
      old_currency_id = insert(:currency, code: "BRL").id

      marketplace = insert(:marketplace)
      shopkeeper = insert(:shopkeeper, marketplace: marketplace)

      old_price1 = Arithmetic.cast!(100, :convert).value
      old_price2 = Arithmetic.cast!(200, :convert).value
      old_price3 = Arithmetic.cast!(300, :convert).value

      insert(:product, marketplace: marketplace, shopkeeper: shopkeeper, price: old_price1)
      insert(:product, marketplace: marketplace, shopkeeper: shopkeeper, price: old_price2)
      insert(:product, marketplace: marketplace, shopkeeper: shopkeeper, price: old_price3)

      {:ok, marketplace: marketplace, old_currency_id: old_currency_id}
    end

    test "updates all product's price when the market currency changed", %{
      marketplace: marketplace,
      old_currency_id: old_currency_id
    } do
      expect(ClientMock, :call, 3, fn _currency_code ->
        {:ok,
         %{
           "USD" => 0.1899
         }}
      end)

      ConvertProductPrices.call({marketplace, old_currency_id})

      response = Repo.all(Product)

      assert [
               %Product{id: _, price: 1_898_999},
               %Product{id: _, price: 3_797_999},
               %Product{id: _, price: 5_697_000}
             ] = response
    end
  end
end
