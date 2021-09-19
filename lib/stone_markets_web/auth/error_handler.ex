defmodule StoneMarketsWeb.Auth.ErrorHandler do
  alias Guardian.Plug.ErrorHandler
  alias Plug.Conn

  @behaviour ErrorHandler

  def auth_error(conn, {error, _reason}, _opts) do
    body = translate_error_resp(error)

    Conn.send_resp(conn, :unauthorized, body)
  end

  defp translate_error_resp(error) do
    case error do
      :invalid_token -> Jason.encode!(%{message: "Provided token is invalid!"})
      :unauthenticated -> Jason.encode!(%{message: "Authentication token is required!"})
      _ -> Jason.encode!(%{message: to_string(error)})
    end
  end
end
