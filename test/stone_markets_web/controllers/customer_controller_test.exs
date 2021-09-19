defmodule StoneMarketsWeb.CustomerControllerTest do
  use StoneMarketsWeb.ConnCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.Arithmetic
  alias StoneMarketsWeb.Auth.Guardian

  describe "create/2" do
    test "creates the customer, when all params are valid", %{conn: conn} do
      params = build(:customer_attrs)

      response =
        conn
        |> post(Routes.customer_path(conn, :create), params)
        |> json_response(:created)

      assert %{
               "data" => %{
                 "account" => %{
                   "balance" => "5.000,00 USD",
                   "id" => _account_id
                 },
                 "address" => "Rua do macarrão, 999",
                 "age" => 18,
                 "cpf" => "99999999999",
                 "id" => _id,
                 "marketplace_id" => _marketplace_id
               }
             } = response
    end
  end

  describe "deposit/2" do
    setup %{conn: conn} do
      customer_account =
        insert(:customer_account, balance: Arithmetic.cast!(15_000, :convert).value)

      customer = customer_account.customer

      {:ok, token, _claims} = Guardian.encode_and_sign(customer)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> put_resp_header("content-type", "application/json")

      {:ok, conn: conn, customer: customer}
    end

    test "creates a deposit to customer when all params are valid", %{
      conn: conn,
      customer: customer
    } do
      params = %{"value" => 5_000}

      expected_response = %{
        "balance" => "20.000,00 USD",
        "customer_id" => customer.id,
        "message" => "Deposit performed successfully!"
      }

      response =
        conn
        |> post(Routes.customer_path(conn, :deposit, customer.id), params)
        |> json_response(:ok)

      assert response === expected_response
    end

    test "returns an error when customer is not authenticated", %{
      conn: conn,
      customer: customer
    } do
      conn = delete_req_header(conn, "authorization")

      params = %{"value" => 1}

      expected_response = %{"message" => "Authentication token is required!"}

      response =
        conn
        |> post(Routes.customer_path(conn, :deposit, customer.id), params)
        |> json_response(:unauthorized)

      assert response === expected_response
    end

    test "returns an error when the value to deposit is not provided", %{
      conn: conn,
      customer: customer
    } do
      expected_response = %{"message" => "Value is required"}

      response =
        conn
        |> post(Routes.customer_path(conn, :deposit, customer.id), %{})
        |> json_response(:bad_request)

      assert response === expected_response
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      customer_account =
        insert(:customer_account, balance: Arithmetic.cast!(15_000, :convert).value)

      customer = customer_account.customer

      {:ok, token, _claims} = Guardian.encode_and_sign(customer)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> put_resp_header("content-type", "application/json")

      {:ok, conn: conn, customer: customer}
    end

    test "returns the corresponding customer by id", %{conn: conn, customer: customer} do
      response =
        conn
        |> get(Routes.customer_path(conn, :show, customer.id))
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "id" => _id,
                 "marketplace_id" => _marketplace_id,
                 "account" => %{
                   "balance" => "15.000,00 USD",
                   "id" => _account_id
                 },
                 "age" => 18,
                 "cpf" => "99999999999"
               }
             } = response
    end

    test "returns an error when customer is not authenticated", %{conn: conn, customer: customer} do
      conn = delete_req_header(conn, "authorization")

      response =
        conn
        |> get(Routes.customer_path(conn, :show, customer.id))
        |> json_response(:unauthorized)

      expected_response = %{"message" => "Authentication token is required!"}

      assert response === expected_response
    end
  end
end
