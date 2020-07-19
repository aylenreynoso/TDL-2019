defmodule Blockchain do

  use GenServer
  @moduledoc """
  Documentation for Blockchain.
  """

  # This is the client

  def new_client() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def insert_client(blockchain_pid, data) do
    GenServer.cast(blockchain_pid, {:insert, data}) #=> :ok
  end

  @impl true
  def handle_cast({:insert, data}, blockchain_list) do

    %Block{hash: prev} = Block.get_struct(hd(blockchain_list))

    {:ok, block_agent} = Block.start_new_block(data, prev)
    Block.update_put_hash(block_agent)

    {:noreply, [block_agent | blockchain_list]}
  end

  def valid_client?(blockchain_pid) do
    GenServer.call(blockchain_pid, {:valid})
  end

  #This is the server

  @impl true
  def init(:ok) do
    blockchain_list = Blockchain.new()
    {:ok, blockchain_list} #state: list of Blocks
  end

  #@impl true
  #def handle_call({:insert, data}, _from, blockchain_list) do

  #  %Block{hash: prev} = Block.get_struct(hd(blockchain_list))

  #  {:ok, block_agent} = Block.start_new_block(data, prev)
  #  Block.update_put_hash(block_agent)

  #  new_state = [block_agent | blockchain_list]

  #  {:reply, new_state ,new_state}
#  end

  @impl true
  def handle_call({:valid}, _from, blockchain_list) do
    valid = Blockchain.valid?(blockchain_list)
    {:reply, valid, blockchain_list}
  end

#-------------------------------------------------------
  @doc """
    creates a new blockchain with a zero block
  """
  def new do
    {:ok, block_agent} = Block.start_new_block()
    Block.update_put_hash(block_agent) #Crypto.put_hash(block_zero)
    [block_agent]
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
