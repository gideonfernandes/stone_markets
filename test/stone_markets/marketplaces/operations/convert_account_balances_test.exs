defmodule StoneMarkets.Marketplaces.Operations.ConvertAccountBalancesTest do
  use StoneMarkets.DataCase, async: true

  import Mox
  import StoneMarkets.Factory

  alias StoneMarkets.{Account, Arithmetic}
  alias StoneMarkets.ExchangerateApi.ClientMock
  alias StoneMarkets.Marketplaces.Operations.ConvertAccountBalances

  describe "call/1" do
    setup do
      old_currency_id = insert(:currency, code: "BRL").id

      marketplace = insert(:marketplace)
      customer = insert(:customer, marketplace: marketplace)
      shopkeeper = insert(:shopkeeper, marketplace: marketplace)

      marketplace_account =
        insert(:marketplace_account,
          marketplace: marketplace,
          balance: Arithmetic.cast!(1000, :convert).value
        )

      shopkeeper_account =
        insert(:shopkeeper_account,
          shopkeeper: shopkeeper,
          balance: Arithmetic.cast!(1500, :convert).value
        )

      customer_account =
        insert(:customer_account,
          customer: customer,
          balance: Arithmetic.cast!(3000, :convert).value
        )

      {:ok,
       marketplace: marketplace,
       old_currency_id: old_currency_id,
       marketplace_account: marketplace_account,
       shopkeeper_account: shopkeeper_account,
       customer_account: customer_account}
    end

    test "updates all accounts's balance when the market currency changed", %{
      marketplace: marketplace,
      old_currency_id: old_currency_id,
      marketplace_account: marketplace_account,
      shopkeeper_account: shopkeeper_account,
      customer_account: customer_account
    } do
      expect(ClientMock, :call, 3, fn _currency_code ->
        {:ok,
         %{
           "USD" => 0.1899
         }}
      end)

      ConvertAccountBalances.call({marketplace, old_currency_id})

      response = [
        Repo.get!(Account, marketplace_account.id),
        Repo.get!(Account, shopkeeper_account.id),
        Repo.get!(Account, customer_account.id)
      ]

      assert [
               %Account{id: _, balance: 18_990_000},
               %Account{id: _, balance: 28_485_000},
               %Account{id: _, balance: 56_970_000}
             ] = response
    end
  end
end
