defmodule StoneMarketsWeb.ShopkeeperViewTest do
  use StoneMarkets.DataCase, async: true

  import Phoenix.View
  import StoneMarkets.Factory

  alias StoneMarkets.Shopkeeper
  alias StoneMarketsWeb.ShopkeeperView

  test "renders shopkeeper.json" do
    shopkeeper = build(:shopkeeper)

    response = render(ShopkeeperView, "shopkeeper.json", shopkeeper: shopkeeper)

    assert %Shopkeeper{} = response
  end

  test "renders index.json" do
    shopkeepers = build_list(2, :shopkeeper)

    response = render(ShopkeeperView, "index.json", shopkeepers: shopkeepers)

    assert %{data: [%Shopkeeper{}, %Shopkeeper{}]} = response
  end

  test "renders show.json" do
    shopkeeper = build(:shopkeeper)

    response = render(ShopkeeperView, "show.json", shopkeeper: shopkeeper)

    assert %{data: %Shopkeeper{}} = response
  end
end
