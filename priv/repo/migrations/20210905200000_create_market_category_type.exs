defmodule StoneMarkets.Repo.Migrations.CreateMarketCategoryType do
  use Ecto.Migration

  def change do
    up_query =
      "CREATE TYPE market_category AS ENUM ('classifieds', 'clothing', 'electronics', 'family', 'housing', 'vehicles')"

    down_query = "DROP TYPE market_category"

    execute(up_query, down_query)
  end
end
