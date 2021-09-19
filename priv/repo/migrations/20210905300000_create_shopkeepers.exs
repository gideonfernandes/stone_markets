defmodule StoneMarkets.Repo.Migrations.CreateShopkeepers do
  use Ecto.Migration

  def change do
    create table(:shopkeepers) do
      add :category, :market_category, null: false
      add :email, :string, null: false
      add :name, :string, null: false
      add :marketplace_id, references(:marketplaces, type: :binary_id, on_delete: :restrict), null: false
      add :nickname, :string, null: false

      timestamps()
    end

    create index(:shopkeepers, [:marketplace_id])
    create unique_index(:shopkeepers, [:marketplace_id, :email])
    create unique_index(:shopkeepers, [:marketplace_id, :nickname])
  end
end
