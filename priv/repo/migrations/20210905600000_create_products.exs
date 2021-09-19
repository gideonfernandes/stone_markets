defmodule StoneMarkets.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add(:amount, :integer, null: false)
      add(:category, :market_category, null: false)
      add(:description, :string, null: false)
      add(:name, :string, null: false)
      add(:price, :bigint, null: false)

      add(:marketplace_id, references(:marketplaces, type: :binary_id, on_delete: :delete_all),
        null: false
      )

      add(:shopkeeper_id, references(:shopkeepers, type: :binary_id, on_delete: :delete_all),
        null: false
      )

      timestamps()
    end

    create(constraint(:products, :amount_must_be_positive, check: "amount > 0"))
    create(constraint(:products, :price_must_be_positive, check: "price > 0"))
    create(index(:products, [:marketplace_id]))
    create(index(:products, [:shopkeeper_id]))
    create(unique_index(:products, [:shopkeeper_id, :name]))
  end
end
