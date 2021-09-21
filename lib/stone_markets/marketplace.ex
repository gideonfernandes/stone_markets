defmodule StoneMarkets.Marketplace do
  @moduledoc """
   This module is responsible for mapping any data source into a Marketplace struct.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias StoneMarkets.{Account, Currency, Customer, Order}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields ~w(default_currency_id email name nickname)a
  @derive {Jason.Encoder, only: ~w(id)a ++ @required_fields}

  schema "marketplaces" do
    field :email, :string
    field :name, :string
    field :nickname, :string

    belongs_to :default_currency, Currency, foreign_key: :default_currency_id
    has_one :account, Account, foreign_key: :marketplace_id, defaults: [balance: 500_000_000]
    has_many :customers, Customer, foreign_key: :marketplace_id
    has_many :orders, Order, foreign_key: :marketplace_id
    has_many :shopkeepers, Order, foreign_key: :marketplace_id
    has_many :shopkeeper_accounts, through: [:shopkeepers, :account]
    has_many :customer_accounts, through: [:customers, :account]

    timestamps()
  end

  @doc false
  def changeset(marketplace \\ %__MODULE__{}, attrs) do
    marketplace
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, StoneMarkets.email_regex())
    |> validate_length(:name, min: 3)
    |> validate_length(:nickname, min: 3)
    |> unique_constraint(:email)
    |> unique_constraint(:nickname)
    |> foreign_key_constraint(:default_currency_id)
    |> no_assoc_constraint(:customers)
    |> no_assoc_constraint(:shopkeepers)
  end
end
