defmodule StoneMarkets.Customers.Create do
  alias Ecto.Multi
  alias StoneMarkets.{Customer, FallbackError, Repo}

  def call(attrs) do
    Multi.new()
    |> Multi.insert(:create_customer, Customer.changeset(attrs))
    |> Multi.run(:insert_account, &insert_account(&1, &2))
    |> Multi.run(:preload_data, &preload_data(&1, &2))
    |> run_transaction()
  end

  defp insert_account(repo, %{create_customer: customer}) do
    customer
    |> Ecto.build_assoc(:account, code: customer.nickname)
    |> repo.insert()
  end

  defp preload_data(repo, %{create_customer: customer}) do
    {:ok, repo.preload(customer, :account)}
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _, _result, _} = error -> FallbackError.call(error)
      {:ok, %{preload_data: customer}} -> {:ok, customer}
    end
  end
end
