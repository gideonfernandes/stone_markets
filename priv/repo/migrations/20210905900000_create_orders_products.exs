defmodule StoneMarkets.Repo.Migrations.CreateOrdersProducts do
  use Ecto.Migration

  def change do
    create table(:orders_products, primary_key: false) do
      add(:order_id, references(:orders, type: :binary_id, on_delete: :delete_all))
      add(:product_id, references(:products, type: :binary_id, on_delete: :delete_all))
    end
  end
end
