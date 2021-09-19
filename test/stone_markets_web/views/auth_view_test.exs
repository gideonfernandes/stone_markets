defmodule StoneMarketsWeb.AuthViewTest do
  use StoneMarkets.DataCase, async: true

  import Phoenix.View
  import StoneMarkets.Factory

  alias StoneMarkets.Customer
  alias StoneMarketsWeb.AuthView

  test "renders show.json" do
    customer = build(:customer)

    token = "an_auth_token"

    response = render(AuthView, "show.json", token: token, customer: customer)

    assert %{data: %{token: ^token, customer: %Customer{}}} = response
  end
end
