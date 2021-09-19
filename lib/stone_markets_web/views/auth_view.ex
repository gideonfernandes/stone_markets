defmodule StoneMarketsWeb.AuthView do
  use StoneMarketsWeb, :view

  alias StoneMarkets.Customer

  def render("show.json", %{token: token, customer: %Customer{} = customer}) do
    %{data: %{token: token, customer: customer}}
  end
end
