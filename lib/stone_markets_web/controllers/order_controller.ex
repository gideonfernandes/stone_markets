defmodule StoneMarketsWeb.OrderController do
  @moduledoc """
  This module is responsible for controlling and handling all order-related
  requests, calling the corresponding business logic module to perform the requested actions.
  """

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
