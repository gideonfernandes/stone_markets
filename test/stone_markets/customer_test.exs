defmodule StoneMarkets.CustomerTest do
  use StoneMarkets.DataCase, async: true

  import StoneMarkets.Factory

  alias Ecto.Changeset
  alias StoneMarkets.Customer

  describe "changeset/2" do
    test "returns a valid changeset, when all attrs are valid" do
      attrs = build(:customer_attrs, %{"name" => "Customer test name"})

      response = Customer.changeset(attrs)

      assert %Changeset{
               changes: %{
                 address: "Rua do macarrão, 999",
                 age: 18,
                 cpf: "99999999999",
                 email: _email,
                 marketplace_id: _marketplace_id,
                 name: "Customer test name",
                 nickname: _nickname,
                 password: "",
                 password_hash: _password_hash
               },
               valid?: true
             } = response
    end

    test "returns an invalid changeset when there are some error" do
      attrs = %{"age" => 17, "address" => "invalid", "email" => "invalid", "nickname" => "00"}

      response = Customer.changeset(attrs)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        cpf: ["can't be blank"],
        email: ["has invalid format"],
        marketplace_id: ["can't be blank"],
        name: ["can't be blank"],
        nickname: ["should be at least 3 character(s)"],
        password: ["can't be blank"]
      }

      assert errors_on(response) === expected_response
    end
  end
end
