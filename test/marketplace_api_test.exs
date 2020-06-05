defmodule MarketplaceApiTest do
  use ExUnit.Case
  doctest MarketplaceApi

  test "greets the world" do
    assert MarketplaceApi.hello() == :world
  end
end
