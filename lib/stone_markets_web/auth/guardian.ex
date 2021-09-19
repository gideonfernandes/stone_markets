defmodule StoneMarketsWeb.Auth.Guardian do
  use Guardian, otp_app: :testing

  alias Testing.{Customer, FallbackError}
  alias Testing.Errors.{InvalidArgs, InvalidCredentials}

  def subject_for_token(%Customer{id: id}, _claims), do: {:ok, id}

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> Testing.fetch_customer()
  end

  def authenticate(%{"email" => email, "password" => password}) do
    with {:ok, customer} <- Testing.fetch_customer_by(:email, email),
         true <- valid_credentials?(password, customer.password_hash),
         {:ok, token, _claims} <- encode_and_sign(customer) do
      {:ok, token, customer}
    else
      false -> {:error, InvalidCredentials.call()}
      error -> FallbackError.call(error)
    end
  end

  def authenticate(_), do: {:error, InvalidArgs.call()}

  defp valid_credentials?(password, hash), do: Pbkdf2.verify_pass(password, hash)
end
