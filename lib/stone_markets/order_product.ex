defmodule StoneMarkets.OrderProduct do
  @moduledoc """
   This module is responsable for mapping any data source into a OrderProduct struct.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias StoneMarkets.{Order, Product}

  @primary_key false
  @foreign_key_type :binary_id
  @required_fields ~w(order_id product_id)a

  schema "orders_products" do
    belongs_to :order, Order, foreign_key: :order_id
    belongs_to :product, Product, foreign_key: :product_id
  end

  def changeset(struct \\ %__MODULE__{}, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:product_id)
  end
end
