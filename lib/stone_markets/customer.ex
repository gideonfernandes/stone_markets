defmodule StoneMarkets.Customer do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset

  alias StoneMarkets.{Account, Marketplace, Order}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields ~w(cpf email marketplace_id name nickname password)a
  @derive {Jason.Encoder,
           only: ~w(id address account age)a ++ (@required_fields -- ~w(password)a)}

  schema "customers" do
    field :address, :string
    field :age, :integer
    field :cpf, :string
    field :email, :string
    field :name, :string
    field :nickname, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    belongs_to :marketplace, Marketplace, foreign_key: :marketplace_id
    has_one :account, Account, foreign_key: :customer_id, defaults: [balance: 500_000_000]
    has_many :orders, Order, foreign_key: :customer_id

    timestamps()
  end

  def changeset(customer \\ %__MODULE__{}, attrs) do
    customer
    |> cast(attrs, @required_fields ++ [:address, :age])
    |> validate_required(@required_fields)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_length(:cpf, is: 11)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:name, min: 3)
    |> validate_length(:nickname, min: 3)
    |> validate_length(:password, min: 6)
    |> put_password_hash()
    |> unique_constraint(:cpf)
    |> unique_constraint(:email)
    |> unique_constraint(:nickname)
    |> foreign_key_constraint(:marketplace_id)
    |> no_assoc_constraint(:orders)
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Map.merge(%{password: ""}, Pbkdf2.add_hash(password)))
  end

  defp put_password_hash(changeset), do: changeset
end
