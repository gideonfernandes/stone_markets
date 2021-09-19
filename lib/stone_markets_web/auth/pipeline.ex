defmodule StoneMarketsWeb.Auth.Pipeline do
  @moduledoc """
  This module implements the auth pipeline for using in private routes.
  """

  use Guardian.Plug.Pipeline, otp_app: :stone_markets

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
