defmodule StoneMarkets.Products.Fetch do
  alias StoneMarkets.{Repo, Product}
  alias StoneMarkets.Errors.ResourceNotFound

  def call(id) do
    case Repo.get(Product, id) do
      %Product{} = product -> {:ok, product}
      nil -> {:error, ResourceNotFound.call("Product")}
    end
  end
end
