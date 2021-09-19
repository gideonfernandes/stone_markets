defmodule StoneMarkets.Marketplaces.Index do
  alias StoneMarkets.{Marketplace, Repo}

  def call, do: {:ok, Repo.all(Marketplace)}
end
