defmodule StoneMarkets.Shopkeepers.CreateTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.{Error, Shopkeeper}
  alias StoneMarkets.Shopkeepers.Create

  describe "call/1" do
    test "creates the shopkeeper" do
      params = build(:shopkeeper_attrs)

      response = Create.call(params)

      assert {:ok, %Shopkeeper{}} = response
    end

    test "returns an error when there are invalid params" do
      params = build(:shopkeeper_attrs, %{"name" => ""})

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
