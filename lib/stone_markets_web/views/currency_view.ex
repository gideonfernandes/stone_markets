defmodule StoneMarketsWeb.CurrencyView do
  use StoneMarketsWeb, :view

  alias StoneMarkets.Currency
  alias StoneMarketsWeb.CurrencyView

  def render("index.json", %{currencies: currencies}) do
    %{data: render_many(currencies, CurrencyView, "currency.json")}
  end

  def render("show.json", %{currency: %Currency{} = currency}) do
    %{data: render_one(currency, CurrencyView, "currency.json")}
  end

  def render("currency.json", %{currency: %Currency{} = currency}), do: currency
end
