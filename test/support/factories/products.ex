defmodule StoneMarkets.Factories.Products do
  import ExMachina, only: [sequence: 2]
  import StoneMarkets.Factory, only: [build: 1, insert: 1]

  alias StoneMarkets.Product

  def product do
    %Product{
      amount: 5,
      category: Enum.random(~w(classifieds clothing electronics family housing vehicles)a),
      description: "Product description",
      name: sequence(:name, &"Product name #{&1}"),
      price: 80_000,
      marketplace: build(:marketplace),
      shopkeeper: build(:shopkeeper)
    }
  end

  def product_attrs do
    %{
      "amount" => 5,
      "category" => Enum.random(~w(classifieds clothing electronics family housing vehicles)a),
      "description" => "Product description",
      "name" => sequence(:name, &"Product name #{&1}"),
      "price" => 80_000,
      "marketplace_id" => insert(:marketplace).id,
      "shopkeeper_id" => insert(:shopkeeper).id
    }
  end
end
