defmodule StoneMarkets.Orders.MultiplyProducts do
  @moduledoc """
  This module is responsible for multiplying the products by the incoming
  product params, considering the product founded by ID an the input products
  amount requested.
  """

  import Ecto.Query, only: [from: 2]

  alias StoneMarkets.{Product, Repo}

  def call(product_params) do
    product_ids = Enum.map(product_params, &Map.get(&1, "id"))

    query = from product in Product, where: product.id in ^product_ids

    query
    |> Repo.all()
    |> Map.new(&{&1.id, &1})
    |> multiply_products(product_params)
  end

  defp multiply_products(products_map, product_params) do
    {:ok, Enum.reduce(product_params, [], &duplicate_by_amount(&1, &2, products_map))}
  end

  defp duplicate_by_amount(%{"id" => id, "amount" => amount}, acc, products_map) do
    current_duplication =
      products_map
      |> Map.get(id)
      |> List.duplicate(amount)

    acc ++ current_duplication
  end
end
