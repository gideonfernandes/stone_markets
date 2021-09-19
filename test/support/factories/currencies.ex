defmodule StoneMarkets.Factories.Currencies do
  import ExMachina, only: [sequence: 2]

  alias StoneMarkets.Currency

  def currency do
    %Currency{
      code: "USD",
      decimal_places: 2,
      name: sequence(:name, &"Currency name #{&1}"),
      number: sequence(:number, &"00#{&1}")
    }
  end

  def currency_attrs do
    %{
      "code" => "USD",
      "decimal_places" => 2,
      "name" => sequence(:name, &"Currency name #{&1}"),
      "number" => sequence(:number, &"00#{&1}")
    }
  end
end
