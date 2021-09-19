defmodule StoneMarketsWeb.AuthView do
  @moduledoc """
  This module is responsible for rendering all auth-related resource.
  """

  use StoneMarketsWeb, :view

  alias StoneMarkets.Customer

  def render("show.json", %{token: token, customer: %Customer{} = customer}) do
    %{data: %{token: token, customer: customer}}
  end
end
