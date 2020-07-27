defmodule BlockchainSupervisor do

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {DynamicSupervisor, name: BlockSupervisor, strategy: :one_for_one},
      {Blockchain, name: Blockchain} #enviara name como opts
    ]
    Supervisor.init(children, strategy: :one_for_all)
  end
end

#{:ok, block} = DynamicSupervisor.start_child(BlockSupervisor, Block)
#espera nombre del supervisor y la especificacion para iniciar al hijo
