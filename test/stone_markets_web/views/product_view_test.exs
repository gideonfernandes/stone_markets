defmodule StoneMarketsWeb.ProductViewTest do
  use StoneMarkets.DataCase, async: true

  import Phoenix.View
  import StoneMarkets.Factory

  alias StoneMarkets.Product
  alias StoneMarketsWeb.ProductView

  test "renders product.json" do
    product = build(:product)

    response = render(ProductView, "product.json", product: product)

    assert %Product{} = response
  end

  test "renders index.json" do
    products = build_list(2, :product)

    response = render(ProductView, "index.json", products: products)

    assert %{data: [%Product{}, %Product{}]} = response
  end

  test "renders show.json" do
    product = build(:product)

    response = render(ProductView, "show.json", product: product)

    assert %{data: %Product{}} = response
  end
end
