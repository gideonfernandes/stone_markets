defmodule StoneMarkets.Products.Fetch do
  @moduledoc """
  This module is responsible for fetch a product by the provided ID.
  """

  alias StoneMarkets.Errors.ResourceNotFound
  alias StoneMarkets.{Product, Repo}

  def call(id) do
    case Repo.get(Product, id) do
      %Product{} = product -> {:ok, product}
      nil -> {:error, ResourceNotFound.call("Product")}
    end
  end
end
