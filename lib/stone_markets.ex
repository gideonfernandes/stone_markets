defmodule StoneMarkets do
  @moduledoc """
  StoneMarkets keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias StoneMarkets.Accounts.Deposit, as: AccountDeposit
  alias StoneMarkets.Currencies.Fetch, as: FetchCurrency
  alias StoneMarkets.Currencies.FetchBy, as: FetchCurrencyBy
  alias StoneMarkets.Currencies.Index, as: IndexCurrencies
  alias StoneMarkets.Customers.Create, as: CreateCustomer
  alias StoneMarkets.Customers.Fetch, as: FetchCustomer
  alias StoneMarkets.Customers.FetchBy, as: FetchCustomerBy
  alias StoneMarkets.Customers.Index, as: IndexCustomers
  alias StoneMarkets.Marketplaces.Create, as: CreateMarketplace
  alias StoneMarkets.Marketplaces.FetchBy, as: FetchMarketplaceBy
  alias StoneMarkets.Marketplaces.Index, as: IndexMarketplaces
  alias StoneMarkets.Marketplaces.Update, as: UpdateMarketplace
  alias StoneMarkets.Orders.Create, as: CreateOrder
  alias StoneMarkets.Products.Create, as: CreateProduct
  alias StoneMarkets.Products.Fetch, as: FetchProduct
  alias StoneMarkets.Products.Index, as: IndexProducts
  alias StoneMarkets.Shopkeepers.Create, as: CreateShopkeeper
  alias StoneMarkets.Shopkeepers.Fetch, as: FetchShopkeeper
  alias StoneMarkets.Shopkeepers.Index, as: IndexShopkeepers

  defdelegate account_deposit(params, account_type), to: AccountDeposit, as: :call
  defdelegate currencies, to: IndexCurrencies, as: :call
  defdelegate fetch_currency(id), to: FetchCurrency, as: :call
  defdelegate fetch_currency_by(field, param), to: FetchCurrencyBy, as: :call
  defdelegate create_customer(params), to: CreateCustomer, as: :call
  defdelegate fetch_customer(id), to: FetchCustomer, as: :call
  defdelegate fetch_customer_by(field, param), to: FetchCustomerBy, as: :call
  defdelegate customers, to: IndexCustomers, as: :call
  defdelegate create_order(params), to: CreateOrder, as: :call
  defdelegate create_marketplace(params), to: CreateMarketplace, as: :call
  defdelegate marketplaces, to: IndexMarketplaces, as: :call
  defdelegate fetch_marketplace_by(field, param), to: FetchMarketplaceBy, as: :call
  defdelegate update_marketplace(params), to: UpdateMarketplace, as: :call
  defdelegate create_product(params), to: CreateProduct, as: :call
  defdelegate fetch_product(id), to: FetchProduct, as: :call
  defdelegate products(params), to: IndexProducts, as: :call
  defdelegate create_shopkeeper(params), to: CreateShopkeeper, as: :call
  defdelegate fetch_shopkeeper(id), to: FetchShopkeeper, as: :call
  defdelegate shopkeepers(params), to: IndexShopkeepers, as: :call
end
