defmodule StoneMarkets.Marketplaces.FetchBy do
  alias StoneMarkets.Errors.ResourceNotFound
  alias StoneMarkets.{FallbackError, Marketplace, Repo}

  def call(field, value) do
    key_value = Map.new([field], fn field -> {field, value} end)

    with %Marketplace{} = marketplace <- Repo.get_by(Marketplace, key_value),
         %Marketplace{} = marketplace_with_account <- Repo.preload(marketplace, :account) do
      {:ok, marketplace_with_account}
    else
      nil -> {:error, ResourceNotFound.call("Marketplace")}
      error -> FallbackError.call(error)
    end
  end
end
