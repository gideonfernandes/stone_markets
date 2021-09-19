defmodule StoneMarkets.Currencies.Index do
  @moduledoc """
  This module is responsible for fetch all currencies.
  """

  alias StoneMarkets.{Currency, Repo}

  def call, do: {:ok, Repo.all(Currency)}
end
