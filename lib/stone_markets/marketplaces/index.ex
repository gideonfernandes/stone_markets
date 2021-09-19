defmodule StoneMarkets.Marketplaces.Index do
  @moduledoc """
  This module is responsible for fetch all marketplaces.
  """

  alias StoneMarkets.{Marketplace, Repo}

  def call, do: {:ok, Repo.all(Marketplace)}
end
