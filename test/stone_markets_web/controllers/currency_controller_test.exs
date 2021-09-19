defmodule StoneMarketsWeb.CurrencyControllerTest do
  use StoneMarketsWeb.ConnCase, async: true

  import StoneMarkets.Factory

  describe "index/2" do
    test "returns all currencies", %{conn: conn} do
      insert_list(2, :currency)

      response =
        conn
        |> get(Routes.currency_path(conn, :index))
        |> json_response(:ok)

      assert %{
               "data" => [
                 %{
                   "code" => _,
                   "decimal_places" => 2,
                   "id" => _,
                   "name" => _,
                   "number" => _
                 },
                 %{
                   "code" => _,
                   "decimal_places" => 2,
                   "id" => _,
                   "name" => _,
                   "number" => _
                 }
               ]
             } = response
    end
  end
end
