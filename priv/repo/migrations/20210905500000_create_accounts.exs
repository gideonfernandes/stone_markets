defmodule StoneMarkets.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :bigint, null: false
      add :code, :string, null: false
      add :customer_id, references(:customers, type: :binary_id, on_delete: :restrict)
      add :marketplace_id, references(:marketplaces, type: :binary_id, on_delete: :restrict)
      add :shopkeeper_id, references(:shopkeepers, type: :binary_id, on_delete: :restrict)

      timestamps()
    end

    create index(:accounts, [:customer_id])
    create index(:accounts, [:marketplace_id])
    create index(:accounts, [:shopkeeper_id])
    create constraint(:accounts, :balance_must_be_positive_or_zero, check: "balance >= 0")
    create unique_index(:accounts, [:code, :customer_id])
    create unique_index(:accounts, [:code, :marketplace_id])
    create unique_index(:accounts, [:code, :shopkeeper_id])
  end
end
