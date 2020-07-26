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

#TODO
#si se cae un bloque
#1- el estado de blockchain sigue teniendo la referencia el proceso chrasheado
#2- el block se restartea con el mismo estado del anterior pero sin put_hash
#porque eso lo hace la funcion insert de blockchain
#solucion
#lo que quiero es que el dynamic supervisor startee el bloque llamando a insert_client
#monitorear para eliminar el proceso crasheado del estado de blockchain
