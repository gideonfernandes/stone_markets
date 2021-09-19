defmodule StoneMarketsWeb.ShopkeeperControllerTest do
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
    test "returns all shopkeepers by marketplace", %{
      conn: conn,
      marketplace: marketplace
    } do
      insert(:shopkeeper)
      insert(:shopkeeper, marketplace: marketplace)
      insert(:shopkeeper, marketplace: marketplace)

      response =
        conn
        |> get(Routes.shopkeeper_path(conn, :index))
        |> json_response(:ok)

      assert %{
               "data" => [
                 %{
                   "category" => _,
                   "email" => _,
                   "id" => _,
                   "marketplace_id" => _,
                   "name" => _,
                   "nickname" => _
                 },
                 %{
                   "category" => _,
                   "email" => _,
                   "id" => _,
                   "marketplace_id" => _,
                   "name" => _,
                   "nickname" => _
                 }
               ]
             } = response
    end

    test "returns all shopkeepers by marketplace & category", %{
      conn: conn,
      marketplace: marketplace
    } do
      insert(:shopkeeper, category: :classifieds, marketplace: marketplace)
      insert(:shopkeeper, category: :electronics, marketplace: marketplace)
      insert(:shopkeeper, category: :electronics, marketplace: marketplace)

      response =
        conn
        |> get(Routes.shopkeeper_path(conn, :index), %{"categories" => "electronics"})
        |> json_response(:ok)

      assert %{
               "data" => [
                 %{
                   "category" => _,
                   "email" => _,
                   "id" => _,
                   "marketplace_id" => _,
                   "name" => _,
                   "nickname" => _
                 },
                 %{
                   "category" => _,
                   "email" => _,
                   "id" => _,
                   "marketplace_id" => _,
                   "name" => _,
                   "nickname" => _
                 }
               ]
             } = response
    end

    test "returns an error when the customer is not authenticated", %{
      conn: conn,
      marketplace: marketplace
    } do
      conn = delete_req_header(conn, "authorization")

      insert(:shopkeeper)
      insert(:shopkeeper, marketplace: marketplace)
      insert(:shopkeeper, marketplace: marketplace)

      expected_response = %{"message" => "Authentication token is required!"}

      response =
        conn
        |> get(Routes.shopkeeper_path(conn, :index))
        |> json_response(:unauthorized)

      assert response === expected_response
    end
  end

  describe "show/2" do
    test "returns the corresponding shopkeeper by id", %{conn: conn} do
      shopkeeper = insert(:shopkeeper, category: "family")

      response =
        conn
        |> get(Routes.shopkeeper_path(conn, :show, shopkeeper.id))
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "category" => "family",
                 "email" => _email,
                 "id" => _id,
                 "marketplace_id" => _marketplace_id,
                 "name" => _name,
                 "nickname" => _nickname
               }
             } = response
    end

    test "returns an error when customer is not authenticated", %{conn: conn} do
      conn = delete_req_header(conn, "authorization")

      shopkeeper = insert(:shopkeeper, category: "family")

      response =
        conn
        |> get(Routes.shopkeeper_path(conn, :show, shopkeeper.id))
        |> json_response(:unauthorized)

      expected_response = %{"message" => "Authentication token is required!"}

      assert response === expected_response
    end
  end
end
