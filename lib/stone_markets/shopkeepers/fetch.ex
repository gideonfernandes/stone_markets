defmodule StoneMarkets.Shopkeepers.Fetch do
  @moduledoc """
  This module is responsible for fetch a shopkeeper by the provided ID.
  """

  alias StoneMarkets.Errors.ResourceNotFound
  alias StoneMarkets.{FallbackError, Repo, Shopkeeper}

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
