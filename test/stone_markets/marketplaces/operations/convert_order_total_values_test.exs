defmodule StoneMarkets.Marketplaces.Operations.ConvertOrderTotalValuesTest do
  use StoneMarkets.DataCase, async: true

  import Mox
  import StoneMarkets.Factory

  alias StoneMarkets.{Arithmetic, Order}
  alias StoneMarkets.ExchangerateApi.ClientMock
  alias StoneMarkets.Marketplaces.Operations.ConvertOrderTotalValues

  describe "call/1" do
    setup do
      old_currency_id = insert(:currency, code: "BRL").id

      marketplace = insert(:marketplace)

      order =
        insert(:order,
          marketplace: marketplace,
          total_value: Arithmetic.cast!(1000, :convert).value
        )

      {:ok, order: order, marketplace: marketplace, old_currency_id: old_currency_id}
    end

    test "updates all order's total_value when the market currency changed", %{
      order: order,
      marketplace: marketplace,
      old_currency_id: old_currency_id
    } do
      expect(ClientMock, :call, 3, fn _currency_code ->
        {:ok,
         %{
           "USD" => 0.1899
         }}
      end)

      ConvertOrderTotalValues.call({marketplace, old_currency_id})

      response = Repo.get!(Order, order.id)

      assert %Order{id: _, total_value: 18_990_000} = response
    end
  end
end
