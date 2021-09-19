defmodule StoneMarkets.Factories.Orders do
  import StoneMarkets.Factory, only: [build: 1, insert: 1, insert: 2]

  alias StoneMarkets.Order
  alias StoneMarkets.Orders.{CalculateTotalValue, MultiplyProducts}

  def order do
    %Order{
      address: "Rua do macarrão, 999",
      customer: build(:customer),
      marketplace: build(:marketplace),
      status: :requested,
      total_value: 50_000
    }
  end

  def order_attrs do
    marketplace = insert(:marketplace)
    customer = insert(:customer, marketplace: marketplace)
    insert(:customer_account, balance: 100_000, customer: customer)
    product = insert(:product, marketplace: marketplace)

    attrs = %{
      "comments" => "Um comentário qualquer",
      "marketplace_id" => marketplace.id,
      "customer_id" => customer.id,
      "address" => "Rua dos macarrões",
      "products" => [
        %{
          "id" => product.id,
          "amount" => 1
        }
      ]
    }

    {:ok, products} = MultiplyProducts.call(attrs["products"])
    {:ok, order_total_price} = CalculateTotalValue.call(products)

    %{
      customer: customer,
      marketplace: marketplace,
      products: products,
      params: Map.put(attrs, "total_value", order_total_price)
    }
  end
end
