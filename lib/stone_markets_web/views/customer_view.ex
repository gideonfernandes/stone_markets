defmodule StoneMarketsWeb.CustomerView do
  use StoneMarketsWeb, :view

  alias StoneMarkets.Customer
  alias StoneMarketsWeb.CustomerView

  def render("customer.json", %{customer: %Customer{} = customer}), do: customer

  def render("index.json", %{customers: customers}) do
    %{data: render_many(customers, CustomerView, "customer.json")}
  end

  def render("show.json", %{customer: %Customer{} = customer}) do
    %{data: render_one(customer, CustomerView, "customer.json")}
  end
end
