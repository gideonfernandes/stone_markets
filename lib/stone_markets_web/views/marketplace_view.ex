defmodule StoneMarketsWeb.MarketplaceView do
  use StoneMarketsWeb, :view

  alias StoneMarkets.Marketplace
  alias StoneMarketsWeb.MarketplaceView

  def render("index.json", %{marketplaces: marketplaces}) do
    %{data: render_many(marketplaces, MarketplaceView, "marketplace.json")}
  end

  def render("show.json", %{marketplace: %Marketplace{} = marketplace}) do
    %{data: render_one(marketplace, MarketplaceView, "marketplace.json")}
  end

  def render("marketplace.json", %{marketplace: %Marketplace{} = marketplace}), do: marketplace
end
