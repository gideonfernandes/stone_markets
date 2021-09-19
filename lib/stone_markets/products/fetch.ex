defmodule StoneMarkets.Products.Fetch do
  alias StoneMarkets.Errors.ResourceNotFound
  alias StoneMarkets.{Product, Repo}

  def call(id) do
    case Repo.get(Product, id) do
      %Product{} = product -> {:ok, product}
      nil -> {:error, ResourceNotFound.call("Product")}
    end
  end
end
