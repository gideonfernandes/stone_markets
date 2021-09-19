defmodule StoneMarkets.Repo.Migrations.CreateMarketplaces do
  use Ecto.Migration

  def change do
    create table(:marketplaces) do
      add(:default_currency_id, references(:currencies, type: :binary_id, on_delete: :restrict),
        null: false
      )

      add(:email, :string, null: false)
      add(:name, :string, null: false)
      add(:nickname, :string, null: false)

      timestamps()
    end

    create(index(:marketplaces, [:default_currency_id]))
    create(unique_index(:marketplaces, [:email]))
    create(unique_index(:marketplaces, [:nickname]))
  end
end
