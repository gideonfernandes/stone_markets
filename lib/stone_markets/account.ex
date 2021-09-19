defmodule StoneMarkets.Account do
  use Ecto.Schema

  import Ecto.Changeset

  alias StoneMarkets.{Customer, Marketplace, Shopkeeper}
  alias StoneMarkets.Marketplaces.FormatMonetaryValue

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields ~w(balance code)a

  schema "accounts" do
    field :balance, :integer
    field :code, :string

    belongs_to :customer, Customer, foreign_key: :customer_id
    belongs_to :marketplace, Marketplace, foreign_key: :marketplace_id
    belongs_to :shopkeeper, Shopkeeper, foreign_key: :shopkeeper_id

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, attrs) do
    struct
    |> cast(attrs, @required_fields ++ ~w(customer_id marketplace_id shopkeeper_id)a)
    |> validate_required(@required_fields)
    |> validate_account_owner(attrs)
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
    |> unique_constraint([:code, :customer_id])
    |> unique_constraint([:code, :shopkeeper_id])
    |> unique_constraint([:code, :marketplace_id])
    |> foreign_key_constraint(:customer_id)
    |> foreign_key_constraint(:shopkeeper_id)
    |> foreign_key_constraint(:marketplace_id)
  end

  defp validate_account_owner(changeset, attrs) do
    attrs
    |> extract_owners()
    |> Enum.reject(&is_nil/1)
    |> Enum.any?()
    |> check_account_owner(changeset)
  end

  defp extract_owners(attrs) do
    [
      Map.get(attrs, "customer_id"),
      Map.get(attrs, "marketplace_id"),
      Map.get(attrs, "shopkeeper_id")
    ]
  end

  defp check_account_owner(true, changeset), do: changeset

  defp check_account_owner(false, changeset) do
    add_error(changeset, :base, "At least one owner is required")
  end
end
