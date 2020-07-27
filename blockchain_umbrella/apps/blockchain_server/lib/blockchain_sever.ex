defmodule BlockchainSever do

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
