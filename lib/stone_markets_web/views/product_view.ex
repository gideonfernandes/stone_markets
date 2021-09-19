defmodule StoneMarketsWeb.ProductView do
  @moduledoc """
  This module is responsible for rendering all product-related resource.
  """

  use StoneMarketsWeb, :view

  alias StoneMarkets.Product
  alias StoneMarketsWeb.ProductView

  def render("index.json", %{products: products}) do
    %{data: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: %Product{} = product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: %Product{} = product}), do: product
end
