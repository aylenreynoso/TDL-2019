defmodule Block do

  use Agent

  defstruct [:data, :timestamp, :prev_hash, :hash]

  @doc """
   starts a new Block
  """
  def start_new_block(data, prev_hash) do
    new_block = new(data, prev_hash)
    Agent.start_link(fn -> new_block end)
  end

  def start_new_block() do
    new_block = zero()
    Agent.start_link(fn -> new_block end)
  end

  @doc """
   Get the struct from the Agent
  """
  #def get(block) do
  #  Agent.get(block)
  #end

  def update_put_hash(block) do
    Agent.update(block, Crypto, :put_hash, []) #manda a state como primer param de la funcion que usamos para updetear
  end

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

  """
  def get_struct(block) do
    Agent.get(block, & &1)
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
