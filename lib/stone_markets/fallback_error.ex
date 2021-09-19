defmodule StoneMarkets.FallbackError do
  alias Ecto.Changeset
  alias StoneMarkets.Error

  def call(error) do
    case error do
      %Changeset{valid?: false} = changeset -> {:error, Error.build(:bad_request, changeset)}
      {:error, %Error{}} = error -> error
      {:ok, {:error, %Error{}} = error} -> error
      {:error, _operation, result, _changes} -> build_error(result)
      {:ok, {:error, result}} -> build_error(result)
      {:error, result} -> build_error(result)
    end
  end

  defp build_error(result), do: {:error, Error.build(:bad_request, result)}
end
