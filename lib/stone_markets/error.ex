defmodule StoneMarkets.Error do
  @moduledoc """
  This module is responsible for building an Error struct with the reason & status error.
  """

  @keys ~w(result status)a

  @enforce_keys @keys

  defstruct @keys

  def build(status, result), do: %__MODULE__{status: status, result: result}
end
