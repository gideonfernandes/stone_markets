defmodule StoneMarkets.Marketplaces.UpdateTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.Marketplaces.Update
  alias StoneMarkets.{Error, Marketplace}

  describe "call/1" do
    test "returns the market with the currency_code updated" do
      marketplace_id = insert(:marketplace).id

      brl_currency_id = insert(:currency, code: "BRL").id

      params = %{"id" => marketplace_id, "currency_code" => "BRL"}

      response = Update.call(params)

      assert {
               :ok,
               %Marketplace{
                 default_currency_id: ^brl_currency_id,
                 id: ^marketplace_id
               },
               [old_currency_id: _old_currency_id]
             } = response
    end

    test "returns an error when the currency by currency_code is not found" do
      marketplace_id = insert(:marketplace).id

      params = %{"id" => marketplace_id, "currency_code" => "WWW"}

      expected_response = {:error, %Error{result: "Currency not found", status: :not_found}}

      response = Update.call(params)

      assert response === expected_response
    end

    test "returns an error when the currency_code is the same of the marketplace" do
      marketplace = insert(:marketplace)

      params = %{"id" => marketplace.id, "currency_code" => marketplace.default_currency.code}

      expected_response =
        {:error, %Error{result: "Currency provided is already current", status: :bad_request}}

      response = Update.call(params)

      assert response === expected_response
    end

    test "returns an error when the currency_code is not provided" do
      marketplace_id = insert(:marketplace).id

      params = %{"id" => marketplace_id}

      expected_response =
        {:error, %Error{result: "Currency code is required", status: :bad_request}}

      response = Update.call(params)

      assert response === expected_response
    end

    test "returns an error when invalid args are provided" do
      insert(:marketplace)

      expected_response = {:error, %Error{result: "Invalid Args", status: :not_acceptable}}

      response = Update.call(%{})

      assert response === expected_response
    end
  end
end
