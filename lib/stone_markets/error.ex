defmodule StoneMarkets.Error do
  @keys ~w(result status)a

  @enforce_keys @keys

  defstruct @keys

  def build(status, result), do: %__MODULE__{status: status, result: result}
end
