defmodule BlockchainSeverTest do
  use ExUnit.Case
  doctest BlockchainSever

  test "greets the world" do
    assert BlockchainSever.hello() == :world
  end
end
