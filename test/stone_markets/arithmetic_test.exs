defmodule StoneMarkets.ArithmeticTest do
  use StoneMarkets.DataCase, async: true

  alias StoneMarkets.{Arithmetic, Error}

  describe "build/1" do
    test "returns a builded Arithmetic struct when a float is provided" do
      expected_response = %Arithmetic{
        conversor: nil,
        original: 50.35692,
        precision: nil,
        value: 50.35692
      }

      response = Arithmetic.build(50.35692)

      assert expected_response === response
    end

    test "returns a builded Arithmetic struct when an integer is provided" do
      expected_response = %Arithmetic{
        conversor: nil,
        original: 50,
        precision: nil,
        value: 50
      }

      response = Arithmetic.build(50)

      assert expected_response === response
    end

    test "returns an error when the provided arg is not a number" do
      expected_response =
        {:error, %Error{result: "Value is not a number", status: :not_acceptable}}

      response = Arithmetic.build("invalid")

      assert expected_response === response
    end
  end

  describe "cast/2" do
    test "returns a converted Arithmetic struct when a float is provided" do
      expected_response =
        {:ok,
         %Arithmetic{
           conversor: 100_000,
           original: 50.356925,
           precision: 5,
           value: 5_035_692
         }}

      response = Arithmetic.cast(50.356925, :convert)

      assert expected_response === response
    end

    test "returns a converted Arithmetic struct when a integer is provided" do
      expected_response =
        {:ok, %Arithmetic{conversor: 100_000, original: 5999, precision: 5, value: 599_900_000}}

      response = Arithmetic.cast(5999, :convert)

      assert expected_response === response
    end

    test "returns a deconverted Arithmetic struct when a integer is provided" do
      expected_response =
        {:ok,
         %Arithmetic{
           conversor: 100_000,
           original: 5_681_999,
           precision: 5,
           value: 56.81999
         }}

      response = Arithmetic.cast(5_681_999, :deconvert)

      assert expected_response === response
    end

    test "returns an error when invalid args are provided" do
      expected_response = {:error, %Error{result: "Invalid Args", status: :not_acceptable}}

      response = Arithmetic.cast(true, true)

      assert expected_response === response
    end
  end

  describe "cast!/2" do
    test "returns a converted Arithmetic struct when a float is provided" do
      expected_response = %Arithmetic{
        conversor: 100_000,
        original: 50.35692,
        precision: 5,
        value: 5_035_692
      }

      response = Arithmetic.cast!(50.35692, :convert)

      assert expected_response === response
    end

    test "returns a converted Arithmetic struct when a integer is provided" do
      expected_response = %Arithmetic{
        conversor: 100_000,
        original: 5999,
        precision: 5,
        value: 599_900_000
      }

      response = Arithmetic.cast!(5999, :convert)

      assert expected_response === response
    end

    test "returns a deconverted Arithmetic struct when a integer is provided" do
      expected_response = %Arithmetic{
        conversor: 100_000,
        original: 5_681_999,
        precision: 5,
        value: 56.81999
      }

      response = Arithmetic.cast!(5_681_999, :deconvert)

      assert expected_response === response
    end
  end
end
