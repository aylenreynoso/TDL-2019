defmodule Blockchain do

  use GenServer
  @moduledoc """
  Documentation for Blockchain.
  """

  # This is the client

  def start_link(opts) do
    #convencion con el nombre start_link
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def insert_client(blockchain_pid, data) do
    GenServer.cast(blockchain_pid, {:insert, data}) #=> :ok
  end

  def valid_client?(blockchain_pid) do
    GenServer.call(blockchain_pid, {:valid})
  end

  def get_state(blockchain_pid) do
    GenServer.call(blockchain_pid, {:get_state})
  end

  #This is the server

  @impl true
  def init(:ok) do
    blockchain_list = Blockchain.new()
    {:ok, blockchain_list} #state: list of Blocks
  end

  @impl true
  def handle_cast({:insert, data}, blockchain_list) do

    %Block{hash: prev} = Block.get_struct(hd(blockchain_list))

    #{:ok, block_agent} = Block.start_link(data, prev) se inica mediante Supervisor
    children_spec = %{
                        id: Block,
                        start: {Block, :start_link, [[data: data, prev_hash: prev]]},
                        restart: :temporary
                      }

    {:ok, block} = DynamicSupervisor.start_child(BlockSupervisor, children_spec)
    #Block.update_put_hash(block) ahora se hashea en block
    Process.monitor(block)
    {:noreply, [block | blockchain_list]}
  end

  @impl true
  def handle_call({:valid}, _from, blockchain_list) do
    valid = Blockchain.valid?(blockchain_list)
    {:reply, valid, blockchain_list}
  end

  @impl true
  def handle_call({:get_state}, _from, blockchain_list) do

    struct_list = Enum.map(blockchain_list, &Block.get_struct/1)
    {:reply, struct_list, blockchain_list}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, blockchain_list) do
    blockchain_list = List.delete(blockchain_list, pid)
    #rehashear todo el blockchain
    {:noreply, blockchain_list}
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
