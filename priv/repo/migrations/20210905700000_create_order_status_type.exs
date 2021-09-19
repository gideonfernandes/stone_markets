defmodule StoneMarkets.Repo.Migrations.CreateOrderStatusType do
  use Ecto.Migration

  def change do
    up_query = "CREATE TYPE order_status AS ENUM ('requested', 'processed')"
    down_query = "DROP TYPE order_status"

    execute(up_query, down_query)
  end
end
