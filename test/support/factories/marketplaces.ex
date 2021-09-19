defmodule StoneMarkets.Factories.Marketplaces do
  import ExMachina, only: [sequence: 2]
  import StoneMarkets.Factory, only: [build: 1, insert: 1]

  alias StoneMarkets.Marketplace

  def marketplace do
    %Marketplace{
      default_currency: build(:currency),
      email: sequence(:email, &"marketplace#{&1}@stone.com.br"),
      name: sequence(:name, &"Marketplace name #{&1}"),
      nickname: sequence(:nickname, &"Market #{&1}")
    }
  end

  def marketplace_attrs do
    %{
      "default_currency_id" => insert(:currency).id,
      "email" => sequence(:email, &"marketplace#{&1}@stone.com.br"),
      "name" => sequence(:name, &"Marketplace name #{&1}"),
      "nickname" => sequence(:nickname, &"Market #{&1}")
    }
  end
end
