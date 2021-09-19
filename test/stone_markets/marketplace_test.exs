defmodule StoneMarkets.MarketplaceTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.Marketplace

  describe "changeset/2" do
    test "returns a valid changeset, when all attrs are valid" do
      attrs = build(:marketplace_attrs, %{"name" => "Marketplace test name"})

      response = Marketplace.changeset(attrs)

      assert %Changeset{
               changes: %{
                 default_currency_id: _,
                 email: _email,
                 name: "Marketplace test name",
                 nickname: _nickname
               },
               valid?: true
             } = response
    end

    test "returns an invalid changeset when there are some error" do
      attrs = %{"email" => "invalid", "nickname" => "00"}

      response = Marketplace.changeset(attrs)

      expected_response = %{
        email: ["has invalid format"],
        name: ["can't be blank"],
        default_currency_id: ["can't be blank"],
        nickname: ["should be at least 3 character(s)"]
      }

      assert errors_on(response) === expected_response
    end
  end
end
