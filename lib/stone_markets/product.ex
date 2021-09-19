defmodule StoneMarkets.Product do
  use Ecto.{Rescope, Schema}

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias StoneMarkets.{Marketplace, Order, Shopkeeper}
  alias StoneMarkets.Marketplaces.FormatMonetaryValue

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @rescope &__MODULE__.with_positive_amount/1
  @required_fields ~w(amount category description name price marketplace_id shopkeeper_id)a
  @market_categories ~w(classifieds clothing electronics family housing vehicles)a
  @derive {Jason.Encoder, only: ~w(id)a ++ @required_fields}

  schema "products" do
    field :amount, :integer
    field :category, Ecto.Enum, values: @market_categories
    field :description, :string
    field :name, :string
    field :price, :integer

    belongs_to :marketplace, Marketplace, foreign_key: :marketplace_id
    belongs_to :shopkeeper, Shopkeeper, foreign_key: :shopkeeper_id
    many_to_many :orders, Order, join_through: "orders_products"

    timestamps()
  end

  @doc false
  def changeset(product \\ %__MODULE__{}, attrs) do
    product
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:description, min: 8)
    |> validate_length(:name, min: 4)
    |> check_constraint(:amount, name: :amount_must_be_positive)
    |> check_constraint(:price, name: :price_must_be_positive)
    |> unique_constraint([:shopkeeper_id, :name])
    |> foreign_key_constraint(:marketplace_id)
    |> foreign_key_constraint(:shopkeeper_id)
  end

  def with_positive_amount(query), do: from(q in query, where: q.amount >= 1)
end
