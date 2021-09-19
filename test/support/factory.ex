defmodule StoneMarkets.Factory do
  use ExMachina.Ecto, repo: StoneMarkets.Repo

  alias StoneMarkets.Factories.Accounts, as: AccountFactories
  alias StoneMarkets.Factories.Currencies, as: CurrencyFactories
  alias StoneMarkets.Factories.Customers, as: CustomerFactories
  alias StoneMarkets.Factories.Marketplaces, as: MarketplaceFactories
  alias StoneMarkets.Factories.Orders, as: OrderFactories
  alias StoneMarkets.Factories.Products, as: ProductFactories
  alias StoneMarkets.Factories.Shopkeepers, as: ShopkeeperFactories

  defdelegate customer_account_factory, to: AccountFactories, as: :customer_account
  defdelegate marketplace_account_factory, to: AccountFactories, as: :marketplace_account
  defdelegate shopkeeper_account_factory, to: AccountFactories, as: :shopkeeper_account
  defdelegate customer_account_attrs_factory, to: AccountFactories, as: :customer_account_attrs

  defdelegate marketplace_account_attrs_factory,
    to: AccountFactories,
    as: :marketplace_account_attrs

  defdelegate shopkeeper_account_attrs_factory,
    to: AccountFactories,
    as: :shopkeeper_account_attrs

  defdelegate currency_factory, to: CurrencyFactories, as: :currency
  defdelegate currency_attrs_factory, to: CurrencyFactories, as: :currency_attrs
  defdelegate customer_factory, to: CustomerFactories, as: :customer
  defdelegate customer_attrs_factory, to: CustomerFactories, as: :customer_attrs
  defdelegate marketplace_factory, to: MarketplaceFactories, as: :marketplace
  defdelegate marketplace_attrs_factory, to: MarketplaceFactories, as: :marketplace_attrs
  defdelegate order_factory, to: OrderFactories, as: :order
  defdelegate order_attrs_factory, to: OrderFactories, as: :order_attrs
  defdelegate product_factory, to: ProductFactories, as: :product
  defdelegate product_attrs_factory, to: ProductFactories, as: :product_attrs
  defdelegate shopkeeper_factory, to: ShopkeeperFactories, as: :shopkeeper
  defdelegate shopkeeper_attrs_factory, to: ShopkeeperFactories, as: :shopkeeper_attrs
end
