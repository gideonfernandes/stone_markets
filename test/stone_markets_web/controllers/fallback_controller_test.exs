defmodule StoneMarketsWeb.FallbackControllerTest do
  use StoneMarketsWeb.ConnCase, async: true

  import StoneMarkets.Factory

  alias StoneMarkets.{Customer, Error}
  alias StoneMarketsWeb.FallbackController

  describe "call/2" do
    test "returns an error message when is called", %{conn: conn} do
      response =
        FallbackController.call(
          conn,
          {:error, %Error{status: :bad_request, result: "Some error message"}}
        )

      assert %Plug.Conn{
               resp_body: "{\"message\":\"Some error message\"}",
               status: 400
             } = response
    end

    test "returns some changeset error messages when an invalid changeset is provided", %{
      conn: conn
    } do
      changeset =
        build(:customer_attrs, %{"name" => ""})
        |> Customer.changeset()

      response =
        FallbackController.call(conn, {:error, %Error{status: :bad_request, result: changeset}})

      assert %Plug.Conn{
               resp_body: "{\"message\":{\"name\":[\"can't be blank\"]}}",
               status: 400
             } = response
    end
  end
end
