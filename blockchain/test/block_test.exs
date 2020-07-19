defmodule BlockTest do
  use ExUnit.Case
  doctest Block

  setup do
    {:ok, block_agent} = Block.start_new_block()
    %{block: block_agent}
  end

  test "get struct from a block", %{block: block_agent} do
    expected_block = %Block{
      data: "ZERO_DATA",
      prev_hash: "ZERO_HASH",
      timestamp: NaiveDateTime.utc_now()
    }

    block_struct = Block.get_struct(block_agent)

    assert block_struct.data == expected_block.data
  end
  test "create block" do

    data = "soy un bloque"
    prev_hash = "3ifj956g928305fh0273hg8045g"
    expected_block = %Block{
      data: data,
      prev_hash: prev_hash,
      timestamp: NaiveDateTime.utc_now()
    }

    {:ok, new_block} = Block.start_new_block(data, prev_hash)
    new_block_struct = Block.get_struct(new_block)

    assert new_block_struct.data == expected_block.data
  end

  test "create Zero block" do

    expected_block = %Block{
      data: "ZERO_DATA",
      prev_hash: "ZERO_HASH",
      timestamp: NaiveDateTime.utc_now()
    }

    {:ok, new_block} = Block.start_new_block()
    new_block_struct = Block.get_struct(new_block)

    assert new_block_struct.data == expected_block.data

  end
end
