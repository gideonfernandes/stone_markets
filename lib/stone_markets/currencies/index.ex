defmodule StoneMarkets.Currencies.Index do
  alias StoneMarkets.{Repo, Currency}

  def call, do: {:ok, Repo.all(Currency)}
end
