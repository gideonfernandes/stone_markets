defmodule StoneMarkets.Currencies.FetchBy do
  alias StoneMarkets.{Repo, Currency}
  alias StoneMarkets.Errors.ResourceNotFound

  def call(field, value) do
    key_value = Map.new([field], fn field -> {field, value} end)

    case Repo.get_by(Currency, key_value) do
      %Currency{} = curency -> {:ok, curency}
      nil -> {:error, ResourceNotFound.call("Currency")}
    end
  end
end
