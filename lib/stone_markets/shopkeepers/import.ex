defmodule StoneMarkets.Shopkeepers.Import do
  @moduledoc """
  This module is responsable for imports all shopkeepers from json fixture file.
  """

  def call do
    with {:ok, iex_marketplace} <- fetch_iex_marketplace(),
         {:ok, mix_marketplace} <- fetch_mix_marketplace(),
         {:ok, pry_marketplace} <- fetch_pry_marketplace(),
         {:ok, iex_shopkeepers_content} <- read_iex_shopkeepers(),
         {:ok, mix_shopkeepers_content} <- read_mix_shopkeepers(),
         {:ok, pry_shopkeepers_content} <- read_pry_shopkeepers(),
         iex_shopkeepers <- decode_shopkeepers(iex_shopkeepers_content),
         mix_shopkeepers <- decode_shopkeepers(mix_shopkeepers_content),
         pry_shopkeepers <- decode_shopkeepers(pry_shopkeepers_content) do
      insert_shopkeepers(iex_shopkeepers, iex_marketplace)
      insert_shopkeepers(mix_shopkeepers, mix_marketplace)
      insert_shopkeepers(pry_shopkeepers, pry_marketplace)
    else
      _ -> "An error occurred creating the shopkeepers..."
    end
  end

  defp fetch_iex_marketplace, do: fetch_marketplace("IEX")
  defp fetch_mix_marketplace, do: fetch_marketplace("MIX")
  defp fetch_pry_marketplace, do: fetch_marketplace("PRY")
  defp fetch_marketplace(nickname), do: StoneMarkets.fetch_marketplace_by(:nickname, nickname)
  defp read_iex_shopkeepers, do: read_shopkeepers("iex_shopkeepers.json")
  defp read_mix_shopkeepers, do: read_shopkeepers("mix_shopkeepers.json")
  defp read_pry_shopkeepers, do: read_shopkeepers("pry_shopkeepers.json")
  defp read_shopkeepers(filename), do: File.read("priv/repo/seeds/fixtures/#{filename}")

  defp decode_shopkeepers(content) do
    content
    |> Jason.decode!()
    |> Map.get("shopkeepers")
  end

  defp insert_shopkeepers(shopkeepers, marketplace) do
    Enum.each(shopkeepers, &do_insert(&1, marketplace))
  end

  defp do_insert(shopkeeper, marketplace) do
    shopkeeper
    |> Map.put("marketplace_id", marketplace.id)
    |> StoneMarkets.create_shopkeeper()
  end
end
