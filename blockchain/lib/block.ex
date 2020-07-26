defmodule Block do

  use Agent

  defstruct [:data, :timestamp, :prev_hash, :hash]

  @doc """
   starts a new Block
  """

  def start_link(opts) do

    {data, opts} = Keyword.pop(opts, :data)
    {prev_hash, _ } = Keyword.pop(opts, :prev_hash)
    new_block = new(data, prev_hash)
    new_block = Crypto.put_hash(new_block)
    Agent.start_link(fn -> new_block end)

  end

  def start_new_block() do #este bloque sera creado fuera del arbol de supervision
    new_block = zero()
    Agent.start_link(fn -> new_block end)
  end

  @doc """
    Get the struct from the Agent
  """
  def get_struct(block) do
    Agent.get(block, & &1)
  end

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

  def valid?(block) do
    block_struct = Block.get_struct(block)
    Crypto.hash(block_struct) == block_struct.hash
  end


  @doc """
    compares the value of the previous block hash to the value stored in prev_hash
  """
  def valid?(block, prev_block) do
    prev_block_struct = Block.get_struct(prev_block)
    block_struct = Block.get_struct(block)
    (Crypto.hash(prev_block_struct) == block_struct.prev_hash) && valid?(block)
  end
end
