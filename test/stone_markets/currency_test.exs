defmodule StoneMarkets.CurrencyTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.Currency

  describe "changeset/2" do
    test "returns a valid changeset, when all attrs are valid" do
      attrs = build(:currency_attrs, %{"name" => "Currency test name"})

      response = Currency.changeset(attrs)

      assert %Changeset{
               changes: %{
                 code: "USD",
                 decimal_places: 2,
                 name: "Currency test name",
                 number: _number
               },
               valid?: true
             } = response
    end

    test "returns an invalid changeset when there are some error" do
      attrs = %{"code" => "WWW", "name" => "00"}

      response = Currency.changeset(attrs)

      expected_response = %{
        code: ["is invalid"],
        name: ["should be at least 3 character(s)"],
        decimal_places: ["can't be blank"],
        number: ["can't be blank"]
      }

      assert errors_on(response) === expected_response
    end
  end
end
