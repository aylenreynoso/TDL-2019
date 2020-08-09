defmodule BlockchainServer do

  require Logger
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, #recibe data como binarios en lugar de listas
                                           packet: :line, #recibe data line by line
                                           active: false, #blockea :gen_tcp.recv/2 hasta que la data este disponible
                                           reuseaddr: true #permite reutilizar la direccion si un listener crashea
                                           ])
    Logger.info("Aceptando conexiones en puerto #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    #Task.start_link(fn-> serve(client) end) si se cae se cae el loop_acceptor
    {:ok, task_pid} = Task.Supervisor.start_child(BlockchainServer.TaskSupervisor, fn -> serve(client) end)

    :ok = :gen_tcp.controlling_process(client, task_pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    #socket |> read_line()|> write_line(socket) serve(socket)
    msg =
      case read_line(socket) do
        {:ok, data} ->
          case BlockchainServer.Command.parse(data) do
            {:ok, command} ->
              BlockchainServer.Command.run(command)
            {:error, _ } = err ->
              err
          end
        {:error, _ } = err ->
          err
      end
    #TODO cambiar clauses a with
    write_line(socket, msg)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, data})do #tupla que retorna run
    :gen_tcp.send(socket, data)
  end

  defp write_line(socket, {:error, :unknown_command}) do
    # Error conocido, informar al cliente
    :gen_tcp.send(socket, "UNKNOWN_COMMAND")
  end

  defp write_line(socket, {:error, :closed}) do
    # Conexion cerrada, salir
    exit(:shutdown)
  end

  defp write_line(socket, {:error, error}) do
    # Error desconocido, informar al cliente y salir
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end
end
