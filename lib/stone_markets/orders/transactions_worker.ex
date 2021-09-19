defmodule StoneMarkets.Orders.TransactionsWorker do
  @moduledoc """
  This module is responsible for executing all necessary transactions
  after a newly created order and is also responsible for executing background
  work runner that finds all requested orders that have not yet been processed for some
  reason and processes them.
  """

  use GenServer

  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset, only: [change: 2]

  require Logger

  alias StoneMarkets.{Order, Repo}
  alias StoneMarkets.Orders.Operations.{ChargeCustomer, SplitPayments}

  def start_link(_initial_state) do
    GenServer.start_link(__MODULE__, %{}, name: TransactionsWorker)
  end

  @impl true
  def init(state) do
    Logger.info("Transactions Worker started!")

    schedule_order_transactions()

    {:ok, state}
  end

  @impl true
  def handle_cast(:process_all, state) do
    query = from order in Order, where: order.status == ^"requested"

    query
    |> Repo.all()
    |> Enum.each(&Process.send(self(), {:process, &1}, [:nosuspend]))

    schedule_order_transactions()

    {:noreply, state}
  end

  @impl true
  def handle_cast({:process, order}, state) do
    Logger.info("Executing order transaction, ID: #{order.id}")

    process_order_transaction(order)

    {:noreply, state}
  end

  defp schedule_order_transactions do
    Process.send_after(self(), :process_all, 1000 * 60 * 60)
  end

  defp process_order_transaction(order) do
    Repo.transaction(fn ->
      ChargeCustomer.call(order)
      SplitPayments.call(order)
      update_to_processed(order)
    end)
  end

  defp update_to_processed(order) do
    order
    |> change(status: :processed)
    |> Repo.update()
  end
end
