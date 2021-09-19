defmodule StoneMarkets.Arithmetic do
  @moduledoc """
  This module is responsible for casting, converting and deconverting numerical values
  to perform arithmetic calculations after transforming floating values ​​to integers.
  """

  @enforce_keys ~w(conversor original precision value)a

  defstruct @enforce_keys

  alias StoneMarkets.Errors.{InvalidArgs, IsNotANumber}

  def build(value) when is_number(value) do
    %__MODULE__{
      conversor: nil,
      original: value,
      precision: nil,
      value: value
    }
  end

  def build(_), do: {:error, IsNotANumber.call()}

  def cast(value, :convert) when is_number(value) do
    {:ok,
     %__MODULE__{
       conversor: 100_000,
       original: value,
       precision: 5,
       value: trunc(value * 100_000)
     }}
  end

  def cast(value, :deconvert) when is_number(value) do
    {:ok,
     %__MODULE__{
       conversor: 100_000,
       original: value,
       precision: 5,
       value: floatify(value / 100_000, 5)
     }}
  end

  def cast(_, _), do: {:error, InvalidArgs.call()}

  def cast!(value, :convert) when is_number(value) do
    %__MODULE__{
      conversor: 100_000,
      original: value,
      precision: 5,
      value: trunc(value * 100_000)
    }
  end

  def cast!(value, :deconvert) when is_number(value) do
    %__MODULE__{
      conversor: 100_000,
      original: value,
      precision: 5,
      value: floatify(value / 100_000, 5)
    }
  end

  defp floatify(value, precision) do
    value
    |> :erlang.float_to_binary(decimals: precision)
    |> String.to_float()
  end
end
