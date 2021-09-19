defmodule StoneMarkets.Orders.CalculateTotalValue do
  @moduledoc """
  This module is responsible for calculating the order total value
  considering the requested products.
  """

  def call(products) do
    {:ok,
     products
     |> Stream.map(& &1.price)
     |> Enum.reduce(&sum_prices(&1, &2))}
  end

  defp sum_prices(price, acc), do: price + acc
end
