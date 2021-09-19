defmodule StoneMarkets.ShopkeeperTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.{Repo, Shopkeeper}

  describe "changeset/2" do
    test "returns a valid changeset, when all attrs are valid" do
      attrs = build(:shopkeeper_attrs, %{"name" => "Shopkeeper test name"})

      response = Shopkeeper.changeset(attrs)

      assert %Changeset{
               changes: %{
                 category: _category,
                 email: _email,
                 marketplace_id: _marketplace_id,
                 name: "Shopkeeper test name",
                 nickname: _nickname
               },
               valid?: true
             } = response
    end

    test "returns an invalid changeset when there are some error" do
      attrs = %{"email" => "invalid", "name" => "00"}

      response = Shopkeeper.changeset(attrs)

      expected_response = %{
        name: ["should be at least 3 character(s)"],
        category: ["can't be blank"],
        email: ["has invalid format"],
        marketplace_id: ["can't be blank"],
        nickname: ["can't be blank"]
      }

      assert errors_on(response) === expected_response
    end

    test "returns an invalid changeset, marketplace is not found" do
      attrs = build(:shopkeeper_attrs, %{"marketplace_id" => Ecto.UUID.generate()})

      response =
        attrs
        |> Shopkeeper.changeset()
        |> Repo.insert()

      assert {:error,
              %Changeset{
                errors: [marketplace_id: {"does not exist", _constraint}],
                valid?: false
              }} = response
    end
  end
end
