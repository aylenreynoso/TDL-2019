defmodule Block do
  defstruct [:data, :timestamp, :prev_hash, :hash]

  @doc """
    Build a new block for given data and previous hash
  """
  def new(data, prev_hash) do
    %Block{
      data: data,
      prev_hash: prev_hash,
      timestamp: NaiveDateTime.utc_now()
    }
  end

  @doc """
    Build the initial block of the chain
  """
  def zero do
    %Block{
      data: "ZERO_DATA",
      prev_hash: "ZERO_HASH",
      timestamp: NaiveDateTime.utc_now()
    }
  end

  @doc """
    calculate the hash of the block and compares it with th stored value
  """
  def valid?(%Block{} = block) do
    Crypto.hash(block) == block.hash
  end

  @doc """
    compares the value of the previous block hash to the value stored in prev_hash
  """
  def valid?(%Block{} = block, %Block{} = prev_block) do
    (Crypto.hash(prev_block) == block.prev_hash) && valid?(block)
  end
end
