defmodule BlockchainServerTest do
  use ExUnit.Case
  doctest BlockchainServer

  test "greets the world" do
    assert BlockchainServer.hello() == :world
  end
end
