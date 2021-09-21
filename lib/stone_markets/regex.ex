defmodule StoneMarkets.Regex do
  def email, do: ~r/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+).(\.[a-z]{2,3})$/
end
