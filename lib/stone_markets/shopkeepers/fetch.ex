defmodule StoneMarkets.Shopkeepers.Fetch do
  alias StoneMarkets.{FallbackError, Repo, Shopkeeper}
  alias StoneMarkets.Errors.ResourceNotFound

  def call(id) do
    with %Shopkeeper{} = shopkeeper <- Repo.get(Shopkeeper, id),
         %Shopkeeper{} = shopkeeper_with_account <- Repo.preload(shopkeeper, :account) do
      {:ok, shopkeeper_with_account}
    else
      nil -> {:error, ResourceNotFound.call("Shopkeeper")}
      error -> FallbackError.call(error)
    end
  end
end
