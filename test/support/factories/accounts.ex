defmodule StoneMarkets.Factories.Accounts do
  import ExMachina, only: [sequence: 2]
  import StoneMarkets.Factory, only: [build: 1, insert: 1]

  alias StoneMarkets.Account

  def customer_account do
    %Account{
      balance: 50_000,
      code: sequence(:code, &"account_code#{&1}"),
      customer: build(:customer)
    }
  end

  def marketplace_account do
    %Account{
      balance: 50_000,
      code: sequence(:code, &"account_code#{&1}"),
      marketplace: build(:marketplace)
    }
  end

  def shopkeeper_account do
    %Account{
      balance: 50_000,
      code: sequence(:code, &"account_code#{&1}"),
      shopkeeper: build(:shopkeeper)
    }
  end

  def customer_account_attrs do
    %{
      "balance" => 50_000,
      "code" => sequence(:code, &"account_code#{&1}"),
      "customer_id" => insert(:customer).id
    }
  end

  def marketplace_account_attrs do
    %{
      "balance" => 50_000,
      "code" => sequence(:code, &"account_code#{&1}"),
      "marketplace_id" => insert(:marketplace).id
    }
  end

  def shopkeeper_account_attrs do
    %{
      "balance" => 50_000,
      "code" => sequence(:code, &"account_code#{&1}"),
      "shopkeeper_id" => insert(:shopkeeper).id
    }
  end
end
