defmodule StoneMarketsWeb.OrderController do
  use StoneMarketsWeb, :controller

  alias StoneMarkets.{BackgroundStorage, Order}
  alias StoneMarketsWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    do_create = fn params ->
      params
      |> Map.put("customer_id", BackgroundStorage.fetch_signed_customer().id)
      |> StoneMarkets.create_order()
    end

    with {:ok, %Order{} = order} <- do_create.(params) do
      GenServer.cast(TransactionsWorker, {:process, order})

      conn
      |> put_status(:created)
      |> render("show.json", order: order)
    end
  end
end
