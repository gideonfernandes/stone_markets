defmodule StoneMarkets.Accounts.Deposit do
  @moduledoc """
  This module is responsible for depositing an amount to a system account.
  """

  alias Ecto.Changeset
  alias StoneMarkets.{Arithmetic, FallbackError, Repo}
  alias StoneMarkets.Errors.{IsNotANumber, IsRequired}

  def call(params, :customer), do: do_customer_deposit(params)

  defp do_customer_deposit(%{"id" => customer_id, "value" => value}) when is_number(value) do
    with {:ok, customer} <- StoneMarkets.fetch_customer(customer_id),
         {:ok, new_balance} <- apply_operation(customer.account.balance, value),
         %Changeset{valid?: true} = changeset <- change_balance(customer, new_balance) do
      Repo.update(changeset)
    else
      error -> FallbackError.call(error)
    end
  end

  defp do_customer_deposit(%{"id" => _id, "value" => _value}), do: {:error, IsNotANumber.call()}
  defp do_customer_deposit(%{"id" => _id}), do: {:error, IsRequired.call("Value")}
  defp change_balance(customer, value), do: Changeset.change(customer.account, %{balance: value})
  defp apply_operation(balance, value), do: {:ok, convert_incoming(value) + balance}
  defp convert_incoming(value), do: Arithmetic.cast!(value, :convert).value
end
