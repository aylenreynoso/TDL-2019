defmodule BlockchainServer do

  require Logger
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, #recibe data como binarios en lugar de listas
                                           packet: :line, #recibe data line by line
                                           active: false, #blockea :gen_tcp.recv/2 hasta que la data este disponible
                                           reuseaddr: true# permite reutilizar la direccion si un listener crashea
                                           ])
    Logger.info("Aceptando conexiones en puerto #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    #Task.start_link(fn-> serve(client) end) si se cae se cae el loop_acceptor
    #Usamos un sup 1:1 build in de Task, start_child(nombre/pid, fn)
    #{:ok, task_pid} = Task.Supervisor.start_child(BlockchainServer.TaskSupervisor, fn -> serve(client) end)
    #This makes the child process the “controlling process” of the client socket.
    #If we didn’t do this, the acceptor would bring down all the clients if it crashed
    #because sockets would be tied to the process that accepted them (which is the default behaviour).
    #:ok = :gen_tcp.controlling_process(client, task_pid)
    serve(client)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)
    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket)do
    :gen_tcp.send(socket, line)
  end
end
