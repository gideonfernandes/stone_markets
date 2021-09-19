defmodule StoneMarketsWeb.MarketplaceControllerTest do
  use StoneMarketsWeb.ConnCase, async: false

  import StoneMarkets.Factory

  describe "index/2" do
    test "returns all marketplaces", %{conn: conn} do
      insert_list(2, :marketplace)

      response =
        conn
        |> get(Routes.marketplace_path(conn, :index))
        |> json_response(:ok)

      assert %{
               "data" => [
                 %{
                   "id" => _,
                   "name" => _,
                   "default_currency_id" => _,
                   "email" => _,
                   "nickname" => _
                 },
                 %{
                   "id" => _,
                   "name" => _,
                   "default_currency_id" => _,
                   "email" => _,
                   "nickname" => _
                 }
               ]
             } = response
    end
  end

  describe "update/2" do
    test "updates the marketplace currency & returns the updated one", %{conn: conn} do
      marketplace = insert(:marketplace)
      insert(:currency, code: "BRL")

      params = %{"currency_code" => "BRL"}

      response =
        conn
        |> patch(Routes.marketplace_path(conn, :update, marketplace.id), params)
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "default_currency_id" => _default_currency_id,
                 "id" => _id
               }
             } = response
    end

    test "returns an error when the marketplace is not found", %{conn: conn} do
      params = %{"currency_code" => "BRL"}

      response =
        conn
        |> patch(Routes.marketplace_path(conn, :update, Ecto.UUID.generate(), params))
        |> json_response(:not_found)

      assert %{"message" => "Marketplace not found"} = response
    end

    test "returns an error when the currency_code is not provided", %{conn: conn} do
      marketplace = insert(:marketplace)

      params = %{}

      response =
        conn
        |> patch(Routes.marketplace_path(conn, :update, marketplace.id, params))
        |> json_response(:bad_request)

      assert %{"message" => "Currency code is required"} = response
    end

    test "returns an error when the currency_code is not found", %{conn: conn} do
      marketplace = insert(:marketplace)

      params = %{"currency_code" => "WWW"}

      response =
        conn
        |> patch(Routes.marketplace_path(conn, :update, marketplace.id, params))
        |> json_response(:not_found)

      assert %{"message" => "Currency not found"} = response
    end
  end
end
