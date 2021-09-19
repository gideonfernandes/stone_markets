defmodule StoneMarkets.Customers.CreateTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.{Customer, Error}
  alias StoneMarkets.Customers.Create

  describe "call/1" do
    test "creates the customer" do
      params = build(:customer_attrs)

      response = Create.call(params)

      assert {:ok, %Customer{}} = response
    end

    test "returns an error when there are invalid params" do
      params = build(:customer_attrs, %{"name" => ""})

      response = Create.call(params)

      assert {
               :error,
               %Error{
                 result: %Changeset{
                   errors: [name: {"can't be blank", [validation: :required]}],
                   valid?: false
                 },
                 status: :bad_request
               }
             } = response
    end
  end
end
