defmodule StoneMarkets.Currencies.Fetch do
  @moduledoc """
  This module is responsible for fetch a currency by the provided ID.
  """

  alias StoneMarkets.{Currency, Repo}
  alias StoneMarkets.Errors.ResourceNotFound

  def call(id) do
    case Repo.get(Currency, id) do
      %Currency{} = currency -> {:ok, currency}
      nil -> {:error, ResourceNotFound.call("Currency")}
    end
  end
end
