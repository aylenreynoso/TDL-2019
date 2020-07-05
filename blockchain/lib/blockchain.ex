defmodule Blockchain do
  @moduledoc """
  Documentation for Blockchain.
  """

  @doc """
    creates a new blockchain with a zero block
  """
  def new do
    [Crypto.put_hash(Block.zero)]
  end

  @doc """
    Inserts the given data as a new block in the blockchain
  """
  def insert(blockchain, data) when is_list(blockchain) do
    %Block{hash: prev} = hd(blockchain) #guarda en prev el hash del bloque head de la cadena

    block =
      data
      |> Block.new(prev)
      |> Crypto.put_hash

    [block | blockchain]
  end

  @doc """
    validates the complete blockchain
  """
  def valid?(blockchain) when is_list(blockchain) do
    zero = Enum.reduce_while(blockchain, nil, fn prev,current ->
      cond do
        current == nil -> {:cont, prev}
        Block.valid?(current, prev)-> {:cont, prev}
        true -> {:halt, false}
      end
    end)

    if zero, do: Block.valid?(zero), else: false
  end
end
