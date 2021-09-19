defmodule StoneMarkets.BackgroundStorage do
  use Agent

  alias StoneMarkets.Customer

  def start_link(_initial_state) do
    Agent.start_link(fn -> initial_state() end, name: __MODULE__)
  end

  def fetch_state, do: Agent.get(__MODULE__, & &1)
  def clear_state, do: Agent.update(__MODULE__, fn _state -> initial_state() end)
  def clear_state_key(key), do: Agent.update(__MODULE__, &Map.put(&1, key, nil))
  def fetch_state_key(key), do: Agent.get(__MODULE__, &Map.get(&1, key))

  def fetch_signed_customer do
    Agent.get(__MODULE__, fn %{signed_customer: customer} -> customer end)
  end

  def storage_signed_customer(%Customer{} = customer) do
    Agent.update(__MODULE__, &%{&1 | signed_customer: customer})
  end

  def fetch_currency_conversion_rates(currency) do
    Agent.get(__MODULE__, fn %{conversion_rates: conversion_rates} ->
      Map.get(conversion_rates, currency)
    end)
  end

  def storage_currency_conversion_rates(currency_code, rates) do
    Agent.update(__MODULE__, fn %{conversion_rates: conversion_rates} = state ->
      %{state | conversion_rates: Map.put(conversion_rates, currency_code, rates)}
    end)
  end

  defp initial_state, do: %{conversion_rates: %{}, signed_customer: nil}
end
