defmodule StoneMarkets.ExchangerateApi.Behaviour do
  @moduledoc """
  This module implements the ExchangerateApi client behavior.
  """

  alias StoneMarkets.Error

  @typep exchangerate_api_response :: {:ok, map()} | {:error, %Error{}}

  @callback call(String.t()) :: exchangerate_api_response
  @callback call(String.t(), String.t()) :: exchangerate_api_response
end
