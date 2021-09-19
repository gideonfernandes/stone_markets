defmodule StoneMarketsWeb.OrderViewTest do
  use StoneMarkets.DataCase, async: true

  import Phoenix.View
  import StoneMarkets.Factory

  alias StoneMarkets.Order
  alias StoneMarketsWeb.OrderView

  test "renders order.json" do
    order = build(:order)

    response = render(OrderView, "order.json", order: order)

    assert %Order{} = response
  end

  test "renders show.json" do
    order = build(:order)

    response = render(OrderView, "show.json", order: order)

    assert %{data: %Order{}} = response
  end
end
