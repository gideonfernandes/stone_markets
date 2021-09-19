defmodule StoneMarketsWeb.ShopkeeperView do
  use StoneMarketsWeb, :view

  alias StoneMarkets.Shopkeeper
  alias StoneMarketsWeb.ShopkeeperView

  def render("index.json", %{shopkeepers: shopkeepers}) do
    %{data: render_many(shopkeepers, ShopkeeperView, "shopkeeper.json")}
  end

  def render("show.json", %{shopkeeper: %Shopkeeper{} = shopkeeper}) do
    %{data: render_one(shopkeeper, ShopkeeperView, "shopkeeper.json")}
  end

  def render("shopkeeper.json", %{shopkeeper: %Shopkeeper{} = shopkeeper}), do: shopkeeper
end
