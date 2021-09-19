defmodule StoneMarkets.Orders.Inputs.CreateOrderSchema do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query
  alias Ecto.{Changeset, UUID}
  alias StoneMarkets.{Product, Repo}

  @required_fields ~w(address customer_id marketplace_id)a

  embedded_schema do
    field :address, :string
    field :customer_id, UUID
    field :marketplace_id, UUID
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:address, min: 6)
    |> validate_products(attrs["products"])
  end

  defp validate_products(changeset, nil), do: add_error(changeset, :products, "can't be blank")
  defp validate_products(changeset, []), do: add_error(changeset, :products, "can't be blank")

  defp validate_products(changeset, [_head | _tail] = products) do
    changeset
    |> validate_product_uuids(products)
    |> validate_product_amounts(products)
    |> validate_persisted_products(products)
    |> validate_product_enough_amounts(products)
  end

  defp validate_product_uuids(changeset, products) do
    products
    |> Stream.map(&UUID.cast(&1["id"]))
    |> Enum.all?(&(&1 != :error))
    |> check_validation(changeset, "All product IDs must be valid")
  end

  defp validate_product_amounts(changeset, products) do
    products
    |> Stream.map(&(is_integer(&1["amount"]) and &1["amount"] > 0))
    |> Enum.all?(&(&1 == true))
    |> check_validation(changeset, "All product amounts must be valid")
  end

  defp validate_persisted_products(%Changeset{valid?: true} = changeset, products) do
    product_ids = Enum.map(products, & &1["id"])

    query = from product in Product, where: product.id in ^product_ids

    products_map =
      query
      |> Repo.all()
      |> Map.new(&{&1.id, &1})

    product_ids
    |> Stream.map(&{&1, Map.get(products_map, &1)})
    |> Enum.all?(fn {_id, value} -> is_struct(value) end)
    |> check_validation(changeset, "Some products were not found")
  end

  defp validate_persisted_products(changeset, _products), do: changeset

  defp validate_product_enough_amounts(%Changeset{valid?: true} = changeset, products) do
    products
    |> Enum.all?(&(Repo.get(Product, &1["id"]).amount >= &1["amount"]))
    |> check_validation(changeset, "Some products do not have enough amount")
  end

  defp validate_product_enough_amounts(changeset, _products), do: changeset

  defp check_validation(true, changeset, _reason), do: changeset
  defp check_validation(false, changeset, reason), do: add_products_error(changeset, reason)
  defp add_products_error(changeset, error), do: add_error(changeset, :products, error)
end
