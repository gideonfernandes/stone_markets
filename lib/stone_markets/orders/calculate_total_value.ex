defmodule StoneMarkets.Orders.CalculateTotalValue do
  def call(products) do
    {:ok,
     products
     |> Stream.map(& &1.price)
     |> Enum.reduce(&sum_prices(&1, &2))}
  end

  defp sum_prices(price, acc), do: price + acc
end
