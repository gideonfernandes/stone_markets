defmodule StoneMarkets.Marketplaces.Operations.ConvertOrderTotalValues do
  import Ecto.Query, only: [from: 2]

  alias StoneMarkets.{Order, Repo}
  alias StoneMarkets.Marketplaces.Operations.CalculateExchange

  def call({marketplace, old_currency_id}) do
    market_id = marketplace.id
    currency_code = marketplace.default_currency.code

    Enum.each(linked_orders(market_id), &do_conversion(&1, currency_code, old_currency_id))

    {:ok, nil}
  end

  defp linked_orders(marketplace_id) do
    query = from order in Order, where: order.marketplace_id == ^marketplace_id

    Repo.all(query)
  end

  defp do_conversion(order, currency_code, old_currency_id) do
    exchanged = CalculateExchange.call(order.total_value, currency_code, old_currency_id)

    order
    |> Ecto.Changeset.change(total_value: exchanged)
    |> Repo.update!()
  end
end
