defmodule StoneMarkets.Shopkeepers.Create do
  alias Ecto.Multi
  alias StoneMarkets.{FallbackError, Shopkeeper, Repo}

  def call(attrs) do
    Multi.new()
    |> Multi.insert(:create_shopkeeper, Shopkeeper.changeset(attrs))
    |> Multi.run(:insert_account, &insert_account(&1, &2))
    |> Multi.run(:preload_data, &preload_data(&1, &2))
    |> run_transaction()
  end

  defp insert_account(repo, %{create_shopkeeper: shopkeeper}) do
    shopkeeper
    |> Ecto.build_assoc(:account, code: shopkeeper.nickname)
    |> repo.insert()
  end

  defp preload_data(repo, %{create_shopkeeper: shopkeeper}) do
    {:ok, repo.preload(shopkeeper, :account)}
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _, _result, _} = error -> FallbackError.call(error)
      {:ok, %{preload_data: shopkeeper}} -> {:ok, shopkeeper}
    end
  end
end
