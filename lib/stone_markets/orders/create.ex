defmodule StoneMarkets.Orders.Create do
  alias Ecto.Changeset
  alias StoneMarkets.{FallbackError, Order, Repo}

  alias StoneMarkets.Orders.{CalculateTotalValue, CheckCustomerPurchasingPower, MultiplyProducts}
  alias StoneMarkets.Orders.Inputs.CreateOrderSchema

  def call(params) do
    result = create_order_transaction(params)

    case result do
      {:ok, {:ok, %Order{} = inserted_order}} -> {:ok, inserted_order}
      error -> FallbackError.call(error)
    end
  end

  defp create_order_transaction(params) do
    Repo.transaction(fn ->
      with %Changeset{valid?: true} <- check_incoming_params(params),
           {:ok, products} <- multiply_products(params),
           {:ok, total_price} <- calculate_order_total_value(products),
           {:ok, _customer_id} <- check_customer_purchasing_power(params, total_price) do
        insert_order(params, total_price, products)
      else
        error -> FallbackError.call(error)
      end
    end)
  end

  defp check_incoming_params(params), do: CreateOrderSchema.changeset(params)
  defp multiply_products(params), do: MultiplyProducts.call(params["products"])
  defp calculate_order_total_value(products), do: CalculateTotalValue.call(products)

  defp check_customer_purchasing_power(%{"customer_id" => customer_id}, total_price) do
    CheckCustomerPurchasingPower.call(customer_id, total_price)
  end

  defp insert_order(params, total_price, products) do
    params
    |> Map.put("total_value", total_price)
    |> Order.changeset(products)
    |> Repo.insert()
  end
end
