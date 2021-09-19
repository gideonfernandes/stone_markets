defmodule StoneMarkets.Shopkeepers.Index do
  @moduledoc """
  This module is responsable for imports all shopkeepers from json fixture file.
  """

  import Ecto.Query

  alias StoneMarkets.{BackgroundStorage, Repo, Shopkeeper}
  alias StoneMarkets.Errors.InvalidCategories

  @marketplace_categories ~w(classifieds clothing electronics family housing vehicles)

  def call(params) do
    params
    |> Map.get("categories")
    |> fetch_products()
  end

  defp fetch_products(categories) when is_nil(categories), do: all_shopkeepers()
  defp fetch_products(categories), do: shopkeepers_by_categories(categories)

  defp all_shopkeepers do
    marketplace_id = BackgroundStorage.fetch_signed_customer().marketplace_id

    query =
      from(shopkeeper in Shopkeeper,
        where: shopkeeper.marketplace_id == ^marketplace_id,
        preload: :account
      )

    {:ok, Repo.all(query)}
  end

  defp shopkeepers_by_categories(categories) do
    splitted_categories = String.split(categories, ",")

    splitted_categories
    |> Enum.all?(&Enum.member?(@marketplace_categories, &1))
    |> do_filtering(splitted_categories)
  end

  defp do_filtering(true, splitted_categories) do
    marketplace_id = BackgroundStorage.fetch_signed_customer().marketplace_id

    query =
      from(shopkeeper in Shopkeeper,
        where:
          shopkeeper.marketplace_id == ^marketplace_id and
            shopkeeper.category in ^splitted_categories,
        preload: :account
      )

    {:ok, Repo.all(query)}
  end

  defp do_filtering(false, _splitted_categories), do: {:error, InvalidCategories.call()}
end
