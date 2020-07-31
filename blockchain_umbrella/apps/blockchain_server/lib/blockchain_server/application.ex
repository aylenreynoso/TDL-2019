defmodule BlockchainServer.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do

    port = String.to_integer(System.get_env("PORT") || "4040")
    children = [
      {Task.Supervisor, name: BlockchainServer.TaskSupervisor}, #supervisor 1:1 build-in de Task
      #{Task, fn -> BlockchainServer.accept(port) end} llama a taks.start_link con la fn
      Supervisor.child_spec({Task, fn -> BlockchainServer.accept(port) end}, restart: :permanent)
      #otra sintaxis para especificar condiciones de starteo para el proceso
      #en este caso piso el default de task que es iniciarse como :temporary
    ]

    opts = [strategy: :one_for_one, name: BlockchainServer.Supervisor]
    Supervisor.start_link(children, opts)

    #Now we have an always running acceptor that starts temporary task processes
    #under an always running task supervisor.
  end
end
