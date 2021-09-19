defmodule StoneMarkets.Orders.Operations.SplitPayments do
  import Ecto.Changeset, only: [change: 2]

  alias StoneMarkets.{Account, Order, Repo}

  def call(%Order{} = order) do
    sales_by_shopkeeper = extract_shopkeeper_sales(order)

    Enum.each(sales_by_shopkeeper, &do_shopkeeper_payment/1)

    {:ok, order}
  end

  defp extract_shopkeeper_sales(order) do
    order.products
    |> Stream.map(& &1.shopkeeper_id)
    |> Stream.uniq()
    |> Enum.into(%{}, &filter_by_shopkeeper_id(&1, order.products))
    |> Enum.map(&put_shopkeeper_sales_total_value/1)
  end

  def filter_by_shopkeeper_id(shopkeeper_id, order_products) do
    {shopkeeper_id, Stream.filter(order_products, &(&1.shopkeeper_id === shopkeeper_id))}
  end

  def put_shopkeeper_sales_total_value({shopkeeper_id, products}) do
    total = Enum.reduce(products, 0, &(&1.price + &2))

    %{id: shopkeeper_id, products: products, sales_total_value: total}
  end

  defp do_shopkeeper_payment(shopkeeper_sale) do
    account = Repo.get_by!(Account, shopkeeper_id: shopkeeper_sale.id)

    account
    |> change(balance: account.balance + shopkeeper_sale.sales_total_value)
    |> Repo.update()
  end
end
