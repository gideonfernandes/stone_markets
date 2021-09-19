defmodule StoneMarkets.Products.Create do
  import Ecto.Changeset, only: [change: 2]

  alias Ecto.Changeset
  alias StoneMarkets.{Arithmetic, FallbackError, Product, Repo}

  def call(attrs) do
    with %Changeset{valid?: true} = changeset <- Product.changeset(attrs),
         {:ok, _product} = result <- insert_product(changeset) do
      result
    else
      error -> FallbackError.call(error)
    end
  end

  defp insert_product(changeset) do
    changeset
    |> change(price: Arithmetic.cast!(changeset.changes.price, :convert).value)
    |> Repo.insert()
  end
end
