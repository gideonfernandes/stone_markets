defmodule StoneMarketsWeb.OrderView do
  use StoneMarketsWeb, :view

  alias StoneMarkets.Order
  alias StoneMarketsWeb.OrderView

  def render("show.json", %{order: %Order{} = order}) do
    %{data: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: %Order{} = order}), do: order
end
