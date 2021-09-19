defmodule StoneMarkets.Marketplaces.Create do
  alias Ecto.Multi
  alias StoneMarkets.{FallbackError, Marketplace, Repo}

  def call(attrs) do
    Multi.new()
    |> Multi.insert(:create_marketplace, Marketplace.changeset(attrs))
    |> Multi.run(:insert_account, &insert_account(&1, &2))
    |> Multi.run(:preload_data, &preload_data(&1, &2))
    |> run_transaction()
  end

  defp insert_account(repo, %{create_marketplace: marketplace}) do
    marketplace
    |> Ecto.build_assoc(:account, code: marketplace.nickname)
    |> repo.insert()
  end

  defp preload_data(repo, %{create_marketplace: marketplace}) do
    {:ok, repo.preload(marketplace, :account)}
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _, _result, _} = error -> FallbackError.call(error)
      {:ok, %{preload_data: marketplace}} -> {:ok, marketplace}
    end
  end
end
