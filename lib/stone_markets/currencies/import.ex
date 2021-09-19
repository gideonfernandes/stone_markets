defmodule StoneMarkets.Currencies.Import do
  @moduledoc """
  This module imports all currencies from json fixture file
  """

  alias StoneMarkets.{Currency, Repo}

  def call(filepath \\ "priv/repo/seeds/fixtures/currencies.json") do
    with {:ok, content} <- File.read(filepath),
         {:ok, currencies} <- decode_currencies(content) do
      insert_importeds(currencies)
    else
      _ -> "An error occurred creating the currencies..."
    end
  end

  defp decode_currencies(content) do
    content
    |> Jason.decode!()
    |> Map.get("currencies")
  end

  defp insert_importeds(currencies), do: Enum.each(currencies, &do_insert/1)

  defp do_insert(currency) do
    currency
    |> Currency.changeset()
    |> Repo.insert!()
  end
end
