defmodule StoneMarkets.Currencies.Index do
  alias StoneMarkets.{Currency, Repo}

  def call, do: {:ok, Repo.all(Currency)}
end
