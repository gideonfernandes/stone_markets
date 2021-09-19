defmodule StoneMarkets.Products.Index do
  import Ecto.Query, only: [from: 2]

  alias StoneMarkets.{BackgroundStorage, Product, Repo}
  alias StoneMarkets.Errors.InvalidCategories

  @marketplace_categories ~w(classifieds clothing electronics family housing vehicles)

  def call(params) do
    params
    |> Map.get("categories")
    |> fetch_products()
  end

  defp fetch_products(categories) when is_nil(categories), do: all_products()
  defp fetch_products(categories), do: products_by_categories(categories)

  defp all_products do
    marketplace_id = BackgroundStorage.fetch_signed_customer().marketplace_id

    query = from(product in Product, where: product.marketplace_id == ^marketplace_id)

    {:ok, Repo.all(query)}
  end

  defp products_by_categories(categories) do
    splitted_categories = String.split(categories, ",")

    splitted_categories
    |> Enum.all?(&Enum.member?(@marketplace_categories, &1))
    |> do_filtering(splitted_categories)
  end

  defp do_filtering(true, splitted_categories) do
    marketplace_id = BackgroundStorage.fetch_signed_customer().marketplace_id

    query =
      from(product in Product,
        where:
          product.marketplace_id == ^marketplace_id and product.category in ^splitted_categories
      )

    {:ok, Repo.all(query)}
  end

  defp do_filtering(false, _splitted_categories), do: {:error, InvalidCategories.call()}
end
