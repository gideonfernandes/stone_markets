defmodule StoneMarketsWeb.Plugs.StorageSigned do
  @moduledoc """
  This module is responsible for storing the client signed in, after requesting a
  private route, acting before calling the controller of the requested resource.
  """

  import Plug.Conn

  alias StoneMarkets.BackgroundStorage

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
