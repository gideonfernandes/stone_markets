defmodule StoneMarketsWeb.Plugs.StorageSigned do
  import Plug.Conn

  alias Testing.BackgroundStorage

  def init(opts), do: opts

  def call(conn, _opts) do
    customer = conn.private.guardian_default_resource

    BackgroundStorage.storage_signed_customer(customer)

    register_before_send(conn, fn conn ->
      BackgroundStorage.clear_state_key(:signed_customer)

      conn
    end)
  end
end
