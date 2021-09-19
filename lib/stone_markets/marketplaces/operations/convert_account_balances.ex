defmodule StoneMarkets.Marketplaces.Operations.ConvertAccountBalances do
  import Ecto.Query, only: [from: 2]

  alias StoneMarkets.Marketplaces.Operations.CalculateExchange
  alias StoneMarkets.{Account, Customer, Repo, Shopkeeper}

  def call({marketplace, old_currency_id}) do
    market_id = marketplace.id
    currency_code = marketplace.default_currency.code

    market_id
    |> linked_accounts(fetch_customer_ids(market_id), fetch_shopkeeper_ids(market_id))
    |> Enum.each(&do_conversion(&1, currency_code, old_currency_id))

    {:ok, nil}
  end

  defp fetch_customer_ids(marketplace_id) do
    query =
      from customer in Customer,
        where: customer.marketplace_id == ^marketplace_id,
        select: customer.id

    Repo.all(query)
  end

  defp fetch_shopkeeper_ids(marketplace_id) do
    query =
      from shopkeeper in Shopkeeper,
        where: shopkeeper.marketplace_id == ^marketplace_id,
        select: shopkeeper.id

    Repo.all(query)
  end

  def linked_accounts(marketplace_id, customer_ids, shopkeeper_ids) do
    query =
      from account in Account,
        where:
          account.marketplace_id == ^marketplace_id or account.shopkeeper_id in ^shopkeeper_ids or
            account.customer_id in ^customer_ids

    Repo.all(query)
  end

  defp do_conversion(account, currency_code, old_currency_id) do
    exchanged = CalculateExchange.call(account.balance, currency_code, old_currency_id)

    account
    |> Ecto.Changeset.change(balance: exchanged)
    |> Repo.update!()
  end
end
