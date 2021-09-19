defmodule StoneMarketsWeb.CustomerController do
  use StoneMarketsWeb, :controller

  alias StoneMarkets.{Account, BackgroundStorage}
  alias StoneMarkets.Marketplaces.FormatMonetaryValue
  alias StoneMarketsWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, customer} <- StoneMarkets.create_customer(params) do
      BackgroundStorage.storage_signed_customer(customer)

      conn
      |> put_status(:created)
      |> render("show.json", customer: customer)
    end
  end

  def deposit(conn, params) do
    with {:ok, %Account{} = account} <- StoneMarkets.account_deposit(params, :customer) do
      conn
      |> put_status(:ok)
      |> json(%{
        balance: FormatMonetaryValue.call(account.balance),
        customer_id: account.customer_id,
        message: "Deposit performed successfully!"
      })
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, customer} <- StoneMarkets.fetch_customer(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", customer: customer)
    end
  end
end
