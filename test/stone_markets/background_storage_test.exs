defmodule StoneMarkets.BackgroundStorageTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{BackgroundStorage, Customer}

  setup do
    BackgroundStorage.clear_state()
  end

  describe "clear_state/0" do
    test "clears the state" do
      BackgroundStorage.storage_signed_customer(insert(:customer))

      BackgroundStorage.clear_state()

      expected_response = %{conversion_rates: %{}, signed_customer: nil}

      response = BackgroundStorage.fetch_state()

      assert response === expected_response
    end
  end

  describe "clear_state_key/1" do
    test "clears the state key" do
      BackgroundStorage.storage_signed_customer(insert(:customer))

      BackgroundStorage.storage_currency_conversion_rates("USD", %{
        "EUR" => 0.8451
      })

      BackgroundStorage.clear_state_key(:signed_customer)

      expected_response = %{
        conversion_rates: %{"USD" => %{"EUR" => 0.8451}},
        signed_customer: nil
      }

      response = BackgroundStorage.fetch_state()

      assert response === expected_response
    end
  end

  describe "fetch_state" do
    test "fetches the state" do
      BackgroundStorage.storage_currency_conversion_rates("USD", %{
        "EUR" => 0.8451
      })

      expected_response = %{
        conversion_rates: %{"USD" => %{"EUR" => 0.8451}},
        signed_customer: nil
      }

      response = BackgroundStorage.fetch_state()

      assert response === expected_response
    end
  end

  describe "fetch_state_key/1" do
    test "fetches the state key" do
      BackgroundStorage.storage_currency_conversion_rates("USD", %{
        "EUR" => 0.8451
      })

      expected_response = %{"USD" => %{"EUR" => 0.8451}}

      response = BackgroundStorage.fetch_state_key(:conversion_rates)

      assert response === expected_response
    end
  end

  describe "fetch_signed_customer/0" do
    test "fetches the signed_customer" do
      BackgroundStorage.storage_signed_customer(insert(:customer))

      response = BackgroundStorage.fetch_signed_customer()

      assert %Customer{} = response
    end
  end

  describe "storage_signed_customer/1" do
    test "stores the signed_customer" do
      BackgroundStorage.storage_signed_customer(insert(:customer))

      response = BackgroundStorage.fetch_state_key(:signed_customer)

      assert %Customer{} = response
    end
  end

  describe "fetch_currency_conversion_rates/1" do
    BackgroundStorage.storage_currency_conversion_rates("USD", %{
      "EUR" => 0.8451
    })

    expected_response = %{"EUR" => 0.8451}

    response = BackgroundStorage.fetch_currency_conversion_rates("USD")

    assert response === expected_response
  end

  describe "storage_currency_conversion_rates/1" do
    test "stores the currency_conversion_rates" do
      BackgroundStorage.storage_currency_conversion_rates("USD", %{
        "EUR" => 0.8451
      })

      expected_response = %{"USD" => %{"EUR" => 0.8451}}

      response = BackgroundStorage.fetch_state_key(:conversion_rates)

      assert response === expected_response
    end
  end
end
