defmodule StoneMarkets.Factories.Customers do
  import ExMachina, only: [sequence: 2]
  import StoneMarkets.Factory, only: [build: 1, insert: 1]

  alias StoneMarkets.Customer

  def customer do
    %Customer{
      address: "Rua do macarrão, 999",
      age: 18,
      cpf: "99999999999",
      email: sequence(:email, &"customer#{&1}@stone.com.br"),
      name: sequence(:name, &"Customer name #{&1}"),
      nickname: sequence(:nickname, &"Customer nickname #{&1}"),
      marketplace: build(:marketplace),
      password: "123456789",
      password_hash: "987654321"
    }
  end

  def customer_attrs do
    %{
      "address" => "Rua do macarrão, 999",
      "age" => 18,
      "cpf" => "99999999999",
      "email" => sequence(:email, &"customer#{&1}@stone.com.br"),
      "name" => sequence(:name, &"Customer name #{&1}"),
      "nickname" => sequence(:nickname, &"Customer nickname #{&1}"),
      "marketplace_id" => insert(:marketplace).id,
      "password" => "123456789",
      "password_hash" => "987654321"
    }
  end
end
