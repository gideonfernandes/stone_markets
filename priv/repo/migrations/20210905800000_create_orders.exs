defmodule StoneMarkets.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:address, :string, null: false)
      add(:comments, :string)

      add(:customer_id, references(:customers, type: :binary_id, on_delete: :delete_all),
        null: false
      )

      add(:marketplace_id, references(:marketplaces, type: :binary_id, on_delete: :delete_all),
        null: false
      )

      add(:status, :order_status, null: false)
      add(:total_value, :bigint, null: false)

      timestamps()
    end

    create(constraint(:orders, :total_value_must_be_positive, check: "total_value > 0"))
    create(index(:orders, [:customer_id]))
    create(index(:orders, [:marketplace_id]))
  end
end
