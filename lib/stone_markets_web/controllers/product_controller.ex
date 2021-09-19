defmodule StoneMarketsWeb.ProductController do
  use StoneMarketsWeb, :controller

  alias StoneMarkets.Product
  alias StoneMarketsWeb.FallbackController

  action_fallback FallbackController

  def index(conn, params) do
    with {:ok, products} <- StoneMarkets.products(params) do
      conn
      |> put_status(:ok)
      |> render("index.json", products: products)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Product{} = product} <- StoneMarkets.fetch_product(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", product: product)
    end
  end
end
