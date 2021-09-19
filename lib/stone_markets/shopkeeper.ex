defmodule StoneMarkets.Shopkeeper do
  @moduledoc """
   This module is responsable for mapping any data source into a Shopkeeper struct.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias StoneMarkets.{Account, Marketplace}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields ~w(category email marketplace_id name nickname)a
  @marketplace_categories ~w(classifieds clothing electronics family housing vehicles)a
  @derive {Jason.Encoder, only: ~w(id account)a ++ @required_fields}

  schema "shopkeepers" do
    field :category, Ecto.Enum, values: @marketplace_categories
    field :email, :string
    field :name, :string
    field :nickname, :string

    belongs_to :marketplace, Marketplace, foreign_key: :marketplace_id
    has_one :account, Account, foreign_key: :shopkeeper_id, defaults: [balance: 500_000_000]

    timestamps()
  end

  @doc false
  def changeset(shopkeeper \\ %__MODULE__{}, attrs) do
    shopkeeper
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:name, min: 3)
    |> validate_length(:nickname, min: 3)
    |> unique_constraint([:marketplace_id, :email])
    |> unique_constraint([:marketplace_id, :nickname])
    |> foreign_key_constraint(:marketplace_id)
  end
end
