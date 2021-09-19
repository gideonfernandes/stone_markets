defmodule StoneMarketsWeb.CustomerViewTest do
  use StoneMarkets.DataCase, async: true

  import Phoenix.View
  import StoneMarkets.Factory

  alias StoneMarkets.Customer
  alias StoneMarketsWeb.CustomerView

  test "renders customer.json" do
    customer = build(:customer)

    response = render(CustomerView, "customer.json", customer: customer)

    assert %Customer{} = response
  end

  test "renders index.json" do
    customers = build_list(2, :customer)

    response = render(CustomerView, "index.json", customers: customers)

    assert %{data: [%Customer{}, %Customer{}]} = response
  end

  test "renders show.json" do
    customer = build(:customer)

    response = render(CustomerView, "show.json", customer: customer)

    assert %{data: %Customer{}} = response
  end
end
