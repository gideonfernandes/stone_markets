defmodule StoneMarkets.AccountTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.Account

  describe "changeset/2" do
    test "returns a valid customer account changeset, when all attrs are valid" do
      attrs = build(:customer_account_attrs, %{"code" => "customer"})

      response = Account.changeset(attrs)

      assert %Changeset{
               changes: %{balance: 50000, code: "customer", customer_id: _customer_id},
               valid?: true
             } = response
    end

    test "returns a valid marketplace account changeset, when all attrs are valid" do
      attrs = build(:marketplace_account_attrs, %{"code" => "marketplace"})

      response = Account.changeset(attrs)

      assert %Changeset{
               changes: %{balance: 50000, code: "marketplace", marketplace_id: _marketplace_id},
               valid?: true
             } = response
    end

    test "returns a valid shopkeeper account changeset, when all attrs are valid" do
      attrs = build(:shopkeeper_account_attrs, %{"code" => "shopkeeper"})

      response = Account.changeset(attrs)

      assert %Changeset{
               changes: %{balance: 50000, code: "shopkeeper", shopkeeper_id: _shopkeeper_id},
               valid?: true
             } = response
    end

    test "returns an invalid changeset when is not provided at least one owner" do
      attrs = %{"balance" => 50_000, "code" => "account_code"}

      response = Account.changeset(attrs)

      expected_response = %{base: ["At least one owner is required"]}

      assert errors_on(response) === expected_response
    end

    test "returns an invalid changeset when there are some error" do
      attrs = %{"marketplace_id" => Ecto.UUID.generate()}

      response = Account.changeset(attrs)

      expected_response = %{
        balance: ["can't be blank"],
        code: ["can't be blank"]
      }

      assert errors_on(response) === expected_response
    end
  end
end
