defmodule StoneMarkets.Products.Import do
  @moduledoc """
  This module is responsible for imports all products from json fixture file.
  """

  import Ecto.Query, only: [from: 2]

  alias StoneMarkets.{Marketplace, Repo, Shopkeeper}

  def call do
    case File.read("priv/repo/seeds/fixtures/products.json") do
      {:ok, content} ->
        products = decode_products(content)
        insert_products(fetch_shopkeepers("IEX"), products)
        insert_products(fetch_shopkeepers("MIX"), products)
        insert_products(fetch_shopkeepers("PRY"), products)

      _ ->
        "An error occurred creating the products..."
    end
  end

  defp decode_products(content) do
    content
    |> Jason.decode!()
    |> Map.get("products")
  end

  defp fetch_shopkeepers(marketplace_nickname) do
    {:ok, %Marketplace{id: id}} =
      StoneMarkets.fetch_marketplace_by(:nickname, marketplace_nickname)

    Repo.all(from shopkeeper in Shopkeeper, where: shopkeeper.marketplace_id == ^id)
  end

  defp insert_products(shopkeepers, products) do
    Enum.each(shopkeepers, &do_inserts(&1, products))
  end

  defp do_inserts(shopkeeper, products) do
    products
    |> Stream.filter(&check_same_category(&1, shopkeeper))
    |> Enum.each(&insert_product(&1, shopkeeper))
  end

  defp check_same_category(%{"category" => category}, shopkeeper) do
    String.to_atom(category) == shopkeeper.category
  end

  defp insert_product(product, shopkeeper) do
    product
    |> Map.put("marketplace_id", shopkeeper.marketplace_id)
    |> Map.put("shopkeeper_id", shopkeeper.id)
    |> StoneMarkets.create_product()
  end
end
