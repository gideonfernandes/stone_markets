defmodule StoneMarkets.Marketplaces.Operations.ConvertProductPrices do
  import Ecto.Query, only: [from: 2]

  alias StoneMarkets.Marketplaces.Operations.CalculateExchange
  alias StoneMarkets.{Product, Repo}

  def call({marketplace, old_currency_id}) do
    market_id = marketplace.id
    currency_code = marketplace.default_currency.code

    Enum.each(linked_products(market_id), &do_conversion(&1, currency_code, old_currency_id))

    {:ok, nil}
  end

  defp linked_products(marketplace_id) do
    query = from product in Product, where: product.marketplace_id == ^marketplace_id

    Repo.all(query)
  end

  defp do_conversion(product, currency_code, old_currency_id) do
    exchanged = CalculateExchange.call(product.price, currency_code, old_currency_id)

    product
    |> Ecto.Changeset.change(price: exchanged)
    |> Repo.update()
  end
end
