defmodule BlockchainTest do
  use ExUnit.Case
  doctest Blockchain

  setup do
    blockchain_pid = start_supervised!(Blockchain)
    %{blockchain: blockchain_pid}
  end

  test "insert a new block", %{blockchain: blockchain_pid} do

    data = "soy un bloque"
    assert :ok == Blockchain.insert_client(blockchain_pid, data)
  end
end
