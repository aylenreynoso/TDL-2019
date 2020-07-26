defmodule BlockchainSupervisor do

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      #Blockchain
      {Blockchain, name: Blockchain}, #enviara name como opts
      {DynamicSupervisor, name: BlockSupervisor, strategy: :one_for_one}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end

#{:ok, block} = DynamicSupervisor.start_child(BlockSupervisor, Block)
#espera nombre del supervisor y la especificacion para iniciar al hijo
