defmodule StoneMarkets.Marketplaces.Index do
  alias StoneMarkets.{Repo, Marketplace}

  def call, do: {:ok, Repo.all(Marketplace)}
end
