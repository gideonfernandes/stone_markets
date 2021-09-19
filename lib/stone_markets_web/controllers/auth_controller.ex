defmodule StoneMarketsWeb.AuthController do
  use StoneMarketsWeb, :controller

  alias StoneMarkets.{BackgroundStorage, Customer}
  alias StoneMarketsWeb.{Auth.Guardian, FallbackController}

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, token, %Customer{} = customer} <- Guardian.authenticate(params) do
      BackgroundStorage.storage_signed_customer(customer)

      conn
      |> put_status(:ok)
      |> render("show.json", token: token, customer: customer)
    end
  end
end
