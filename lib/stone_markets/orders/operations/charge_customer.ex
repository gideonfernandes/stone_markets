defmodule StoneMarkets.Orders.Operations.ChargeCustomer do
  import Ecto.Changeset, only: [change: 2]

  alias StoneMarkets.{Customer, Repo}

  def call(order) do
    {:ok, %Customer{account: customer_account}} = StoneMarkets.fetch_customer(order.customer_id)

    do_customer_charge(customer_account, order)
  end

  defp do_customer_charge(account, order) do
    {:ok, updated_account} =
      account
      |> change(balance: account.balance - order.total_value)
      |> Repo.update()

    {:ok, updated_account.balance}
  end
end
