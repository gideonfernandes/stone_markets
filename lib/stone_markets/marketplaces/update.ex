defmodule StoneMarkets.Marketplaces.Update do
  alias StoneMarkets.{FallbackError, Marketplace, Repo}

  alias StoneMarkets.Errors.{
    CurrencyCodeIsRequired,
    CurrencyProvidedIsAlreadyCurrent,
    InvalidArgs,
    ResourceNotFound
  }

  def call(%{"id" => id, "currency_code" => currency_code}) do
    with %Marketplace{} = marketplace <- Repo.get(Marketplace, id),
         {:ok, currency} <- StoneMarkets.fetch_currency_by(:code, currency_code),
         true <- is_already_current_currency?(currency, marketplace),
         {:ok, marketplace} <- do_update(marketplace, currency.id) do
      {:ok, marketplace, old_currency_id: marketplace.default_currency_id}
    else
      nil -> {:error, ResourceNotFound.call("Marketplace")}
      false -> {:error, CurrencyProvidedIsAlreadyCurrent.call()}
      error -> FallbackError.call(error)
    end
  end

  def call(%{"id" => _id}), do: {:error, CurrencyCodeIsRequired.call()}
  def call(_), do: {:error, InvalidArgs.call()}

  defp is_already_current_currency?(currency, market) do
    currency.id !== market.default_currency_id
  end

  defp do_update(marketplace, currency_id) do
    marketplace
    |> Marketplace.changeset(%{default_currency_id: currency_id})
    |> Repo.update()
  end
end
