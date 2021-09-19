defmodule StoneMarketsWeb.AuthControllerTest do
  use StoneMarketsWeb.ConnCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Customer, Repo}

  describe "create/2" do
    setup %{conn: conn} do
      customer_attrs = build(:customer_attrs)

      {:ok, customer} =
        customer_attrs
        |> Customer.changeset()
        |> Repo.insert()

      {:ok, conn: conn, customer: customer, password: customer_attrs["password"]}
    end

    test "returns an authenticated customer when there are valid credentials", %{
      conn: conn,
      customer: customer,
      password: password
    } do
      params = %{"email" => customer.email, "password" => password}

      response =
        conn
        |> post(Routes.auth_path(conn, :create, params))
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "customer" => %{
                   "address" => "Rua do macarrão, 999",
                   "age" => 18,
                   "cpf" => "99999999999",
                   "id" => _id,
                   "marketplace_id" => _marketplace_id
                 },
                 "token" => _token
               }
             } = response
    end

    test "returns an error when there are invalid credentials", %{
      conn: conn,
      customer: customer
    } do
      params = %{"email" => customer.email, "password" => "654321"}

      expected_response = %{"message" => "Please verify your credentials"}

      response =
        conn
        |> post(Routes.auth_path(conn, :create, params))
        |> json_response(:unauthorized)

      assert response === expected_response
    end

    test "returns an error when the customer by email is not found", %{conn: conn} do
      params = %{"email" => "test_not_found@gmail.com", "password" => "123456"}

      expected_response = %{"message" => "Customer not found"}

      response =
        conn
        |> post(Routes.auth_path(conn, :create, params))
        |> json_response(:not_found)

      assert response === expected_response
    end
  end
end
