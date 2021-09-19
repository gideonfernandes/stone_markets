defmodule StoneMarkets.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add(:address, :string)
      add(:age, :integer)
      add(:cpf, :string, null: false)
      add(:email, :string, null: false)
      add(:name, :string, null: false)
      add(:nickname, :string, null: false)

      add(:marketplace_id, references(:marketplaces, type: :binary_id, on_delete: :delete_all),
        null: false
      )

      add(:password_hash, :string, null: false)

      timestamps()
    end

    create(index(:customers, [:marketplace_id]))
    create(unique_index(:customers, [:cpf]))
    create(unique_index(:customers, [:email]))
    create(unique_index(:customers, [:nickname]))
  end
end
