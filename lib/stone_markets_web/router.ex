defmodule StoneMarketsWeb.Router do
  use StoneMarketsWeb, :router

  alias StoneMarketsWeb.Plugs.{StorageSigned, UUIDChecker}

  pipeline :api do
    plug :accepts, ["json"]
    plug UUIDChecker
  end

  pipeline :auth do
    plug StoneMarketsWeb.Auth.Pipeline
    plug StorageSigned
  end

  scope "/api", StoneMarketsWeb do
    pipe_through :api

    resources "/auth", AuthController, only: ~w(create)a
    resources "/currencies", CurrencyController, only: ~w(index)a
    resources "/customers", CustomerController, only: ~w(create)a
    resources "/marketplaces", MarketplaceController, only: ~w(index update)a
  end

  scope "/api", StoneMarketsWeb do
    pipe_through [:auth, :api]

    post "/customers/:id/deposit", CustomerController, :deposit
    post "/currencies/exchange", CurrencyController, :exchange
    resources "/customers", CustomerController, only: ~w(show)a
    resources "/orders", OrderController, only: ~w(create)a
    resources "/products", ProductController, only: ~w(index show)a
    resources "/shopkeepers", ShopkeeperController, only: ~w(index show)a
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: StoneMarketsWeb.Telemetry
    end
  end
end
