defmodule StoneMarketsWeb.ProductControllerTest do
  use StoneMarketsWeb.ConnCase, async: true

  import StoneMarkets.Factory

  alias StoneMarketsWeb.Auth.Guardian

  setup %{conn: conn} do
    marketplace = insert(:marketplace)
    customer = insert(:customer, marketplace: marketplace)

    {:ok, token, _claims} = Guardian.encode_and_sign(customer)

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> put_resp_header("content-type", "application/json")

    {:ok, conn: conn, marketplace: marketplace}
  end

  describe "index/2" do
    test "returns all products by marketplace", %{conn: conn, marketplace: marketplace} do
      insert(:product)
      insert(:product, marketplace: marketplace)
      insert(:product, marketplace: marketplace)

      response =
        conn
        |> get(Routes.product_path(conn, :index))
        |> json_response(:ok)

      assert %{
               "data" => [
                 %{"category" => _, "id" => _, "marketplace_id" => _, "name" => _},
                 %{"category" => _, "id" => _, "marketplace_id" => _, "name" => _}
               ]
             } = response
    end

    test "returns all products by marketplace & category", %{
      conn: conn,
      marketplace: marketplace
    } do
      insert(:product, category: :classifieds, marketplace: marketplace)
      insert(:product, category: :electronics, marketplace: marketplace)
      insert(:product, category: :electronics, marketplace: marketplace)

      response =
        conn
        |> get(Routes.product_path(conn, :index), %{"categories" => "electronics"})
        |> json_response(:ok)

      assert %{
               "data" => [
                 %{"category" => _, "id" => _, "marketplace_id" => _, "name" => _},
                 %{"category" => _, "id" => _, "marketplace_id" => _, "name" => _}
               ]
             } = response
    end

    test "returns an error when customer is not authenticated", %{
      conn: conn,
      marketplace: marketplace
    } do
      conn = delete_req_header(conn, "authorization")

      insert(:product)
      insert(:product, marketplace: marketplace)
      insert(:product, marketplace: marketplace)

      expected_response = %{"message" => "Authentication token is required!"}

      response =
        conn
        |> get(Routes.product_path(conn, :index))
        |> json_response(:unauthorized)

      assert response === expected_response
    end
  end

  describe "show/2" do
    test "returns the corresponding product by id", %{conn: conn} do
      product = insert(:product, category: "electronics")

      response =
        conn
        |> get(Routes.product_path(conn, :show, product.id))
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "category" => "electronics",
                 "id" => _id,
                 "marketplace_id" => _marketplace_id,
                 "name" => _name
               }
             } = response
    end

    test "returns an error when customer is not authenticated", %{conn: conn} do
      conn = delete_req_header(conn, "authorization")

      product = insert(:product, category: "electronics")

      response =
        conn
        |> get(Routes.product_path(conn, :show, product.id))
        |> json_response(:unauthorized)

      expected_response = %{"message" => "Authentication token is required!"}

      assert response === expected_response
    end
  end
end
