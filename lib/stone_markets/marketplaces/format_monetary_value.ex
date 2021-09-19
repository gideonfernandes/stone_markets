defmodule StoneMarkets.Marketplaces.FormatMonetaryValue do
  @moduledoc """
  This module is responsible for formatting an incoming number into a monetary string,
  considering the current currency of the market linked to the signed customer.
  It memorizes the last currency fetched by the signed customer to avoid unnecessary queries.
  """

  use Memoize
  alias StoneMarkets.{Arithmetic, BackgroundStorage, Repo}

  def call(value) when is_number(value) do
    [non_decimals, decimals] =
      extract_number_places(Arithmetic.cast!(value, :deconvert).value, current_market_currency())

    non_decimals = prepare_non_decimal_places(non_decimals)

    do_formatation([non_decimals, decimals])
  end

  def call(_), do: "invalid value"

  defp extract_number_places(number, currency) do
    number
    |> :erlang.float_to_binary(decimals: currency.decimal_places)
    |> String.split(".")
  end

  defp prepare_non_decimal_places(non_decimal_places) do
    non_decimal_places
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.join(".")
    |> String.graphemes()
    |> Enum.reverse()
  end

  defp do_formatation(prepared_number_places) do
    prepared_number_places
    |> Enum.join(",")
    |> remove_first_character_if_starts_with("0")
    |> remove_first_character_if_starts_with(".")
    |> put_currency_code(current_market_currency().code)
  end

  defp remove_first_character_if_starts_with(string_number, to_remove) do
    string_number
    |> must_remove?(to_remove)
    |> handle_remove(string_number)
  end

  defp must_remove?(value, must_remove) do
    String.starts_with?(value, must_remove) and !String.starts_with?(value, must_remove <> ",")
  end

  defp handle_remove(true, string_number) do
    String.slice(string_number, 1, String.length(string_number))
  end

  defp handle_remove(false, string_number), do: string_number

  defp put_currency_code(value, code), do: "#{value} #{code}"

  defmemo current_market_currency do
    customer =
      BackgroundStorage.fetch_signed_customer()
      |> Repo.preload(marketplace: :default_currency)

    customer.marketplace.default_currency
  end
end
