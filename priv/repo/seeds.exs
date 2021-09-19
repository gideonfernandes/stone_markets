# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StoneMarkets.Repo.insert!(%StoneMarkets.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

require Logger

alias StoneMarkets.{Currency, Marketplace, Product, Repo, Shopkeeper}
alias StoneMarkets.Currencies.Import, as: ImportCurrencies
alias StoneMarkets.Marketplaces.Import, as: ImportMarketplaces
alias StoneMarkets.Products.Import, as: ImportProducts
alias StoneMarkets.Shopkeepers.Import, as: ImportShopkeepers

already_imported_log = fn entity -> Logger.info("#{entity} is already imported...") end

do_import = fn entity, import_module ->
  Logger.info("Importing #{entity}...")
  import_module.call()
  Logger.info("#{entity} created successfully!")
end

import_currencies = fn ->
  case Repo.exists?(Currency) do
    true -> already_imported_log.("Currencies")
    false -> do_import.("Currencies", ImportCurrencies)
  end
end

import_markets = fn ->
  case Repo.exists?(Marketplace) do
    true -> already_imported_log.("Marketplaces")
    false -> do_import.("Marketplaces", ImportMarketplaces)
  end
end

import_shopkeepers = fn ->
  case Repo.exists?(Shopkeeper) do
    true -> already_imported_log.("Shopkeepers")
    false -> do_import.("Shopkeepers", ImportShopkeepers)
  end
end

import_products = fn ->
  case Repo.exists?(Product) do
    true -> already_imported_log.("Products")
    false -> do_import.("Products", ImportProducts)
  end
end

import_currencies.()
import_markets.()
import_shopkeepers.()
import_products.()
