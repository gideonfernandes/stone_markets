defmodule StoneMarkets.Currencies.Fetch do
  alias StoneMarkets.{Currency, Repo}
  alias StoneMarkets.Errors.ResourceNotFound

  def call(id) do
    case Repo.get(Currency, id) do
      %Currency{} = currency -> {:ok, currency}
      nil -> {:error, ResourceNotFound.call("Currency")}
    end
  end
end
