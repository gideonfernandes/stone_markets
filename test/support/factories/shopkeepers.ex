defmodule StoneMarkets.Factories.Shopkeepers do
  import ExMachina, only: [sequence: 2]
  import StoneMarkets.Factory, only: [build: 1, insert: 1]

  alias StoneMarkets.Shopkeeper

  def shopkeeper do
    %Shopkeeper{
      category: Enum.random(~w(classifieds clothing electronics family housing vehicles)a),
      email: sequence(:email, &"shopkeeper#{&1}@stone.com.br"),
      name: sequence(:name, &"Shopkeeper name #{&1}"),
      marketplace: build(:marketplace),
      nickname: sequence(:nickname, &"Shopkeeper nickname #{&1}")
    }
  end

  def shopkeeper_attrs do
    %{
      "category" => Enum.random(~w(classifieds clothing electronics family housing vehicles)a),
      "email" => sequence(:email, &"shopkeeper#{&1}@stone.com.br"),
      "name" => sequence(:name, &"Shopkeeper name #{&1}"),
      "marketplace_id" => insert(:marketplace).id,
      "nickname" => sequence(:nickname, &"Shopkeeper nickname #{&1}")
    }
  end
end
