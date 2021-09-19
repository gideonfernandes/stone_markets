defmodule StoneMarkets.Order do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias StoneMarkets.{Customer, Marketplace, OrderProduct, Product}
  alias StoneMarkets.Marketplaces.FormatMonetaryValue

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields ~w(address customer_id marketplace_id total_value)a
  @statuses ~w(requested processed)a

  schema "orders" do
    field :address, :string
    field :comments, :string
    field :status, Ecto.Enum, values: @statuses
    field :total_value, :integer

    belongs_to :customer, Customer, foreign_key: :customer_id
    belongs_to :marketplace, Marketplace, foreign_key: :marketplace_id
    many_to_many :products, Product, join_through: OrderProduct

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, attrs, products) do
    struct
    |> cast(attrs, @required_fields ++ [:comments])
    |> validate_required(@required_fields)
    |> put_assoc(:products, products)
    |> validate_length(:address, min: 6)
    |> validate_length(:comments, min: 6)
    |> check_constraint(:total_value, name: :total_value_must_be_positive)
    |> foreign_key_constraint(:customer_id)
    |> foreign_key_constraint(:marketplace_id)
    |> put_status()
  end

  defp put_status(%Changeset{valid?: true} = changeset) do
    change(changeset, %{status: :requested})
  end

  defp put_status(changeset), do: changeset
end
