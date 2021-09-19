defmodule StoneMarkets.Accounts.DepositTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.Accounts.Deposit
  alias StoneMarkets.{Account, Error}

  describe "call/2" do
    test "deposits by customer ID" do
      customer_id = insert(:customer_account, balance: 100_000_000).customer_id

      params = %{"id" => customer_id, "value" => 250}

      response = Deposit.call(params, :customer)

      assert {:ok, %Account{balance: 125_000_000}} = response
    end

    test "returns an error when the value is invalid" do
      customer_id = insert(:customer_account, balance: 100_000_000).customer_id

      params = %{"id" => customer_id, "value" => "invalid"}

      expected_response =
        {:error, %Error{result: "Value is not a number", status: :not_acceptable}}

      response = Deposit.call(params, :customer)

      assert response === expected_response
    end

    test "returns an error when the value is not provided" do
      customer_id = insert(:customer_account, balance: 100_000_000).customer_id

      params = %{"id" => customer_id}

      expected_response = {:error, %Error{result: "Value is required", status: :bad_request}}

      response = Deposit.call(params, :customer)

      assert response === expected_response
    end
  end
end
