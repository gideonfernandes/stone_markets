defmodule StoneMarkets.Orders.CheckCustomerPurchasingPower do
  @moduledoc """
  This module is responsible for validating if the buyer customer has
  enough money to actually purchase the newly ordered order.
  """

  alias StoneMarkets.Customer
  alias StoneMarkets.Errors.CustomerDoesNotHaveEnoughMoney

  def call(customer_id, order_total_price) do
    customer_id
    |> StoneMarkets.fetch_customer()
    |> customer_is_persisted?()
    |> do_check(order_total_price)
    |> have_enough_money?(customer_id)
  end

  defp customer_is_persisted?({:ok, %Customer{account: customer_account}}), do: customer_account
  defp customer_is_persisted?(error), do: error
  defp do_check(account, order_total_price), do: account.balance >= order_total_price
  defp have_enough_money?(true, customer_id), do: {:ok, customer_id}
  defp have_enough_money?(false, _), do: {:error, CustomerDoesNotHaveEnoughMoney.call()}
end
