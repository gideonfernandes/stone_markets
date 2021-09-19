defmodule StoneMarkets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the BackgroundStorage agent
      StoneMarkets.BackgroundStorage,
      # Start the CurrencyConvertWorker gen_server
      StoneMarkets.Marketplaces.CurrencyConvertWorker,
      # Start the TransactionsWorker gen_server
      StoneMarkets.Orders.TransactionsWorker,
      # Start the Ecto repository
      StoneMarkets.Repo,
      # Start the Telemetry supervisor
      StoneMarketsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: StoneMarkets.PubSub},
      # Start the Endpoint (http/https)
      StoneMarketsWeb.Endpoint
      # Start a worker by calling: StoneMarkets.Worker.start_link(arg)
      # {StoneMarkets.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StoneMarkets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    StoneMarketsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
