defmodule StoneMarketsWeb.Plugs.UUIDChecker do
  import Plug.Conn

  alias Ecto.UUID
  alias Plug.Conn

  @uuid_types ~w(id customer_id default_currency_id marketplace_id shopkeeper_id)

  def init(opts), do: opts

  def call(%Conn{params: params} = conn, _opts) do
    check_map_key = fn uuid_type ->
      if Map.has_key?(params, uuid_type), do: is_valid_uuid?({conn, params, uuid_type})
    end

    Enum.each(@uuid_types, &check_map_key.(&1))

    conn
  end

  def call(%Conn{} = conn, _opts), do: conn

  defp is_valid_uuid?({conn, params, type}) do
    id = Map.get(params, type)

    case UUID.cast(id) do
      {:ok, _uuid} -> conn
      :error -> handle_error_resp(conn, type)
    end
  end

  defp handle_error_resp(conn, type) when type === "id" do
    render_error(conn, "Invalid UUID format")
  end

  defp handle_error_resp(conn, type), do: render_error(conn, "Invalid #{type} format")

  defp render_error(conn, message) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:bad_request, Jason.encode!(%{message: message}))
    |> halt()
  end
end
