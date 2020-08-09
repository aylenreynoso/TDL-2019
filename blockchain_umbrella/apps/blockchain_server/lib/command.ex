defmodule BlockchainServer.Command do
  @doc ~S"""
    Parsea la lina dada a un comando
    ##Ejemplo
        iex> BlockchainServer.Command.parse("INSERT data\r\n")
        {:ok, {:insert, "data"}}
  """

  def parse(line) do
    case String.split(line)do
      ["INSERT", data] -> {:ok, {:insert, data}}
      ["INSERT"] -> {:ok, {:insert}}
      _ -> {:error, :unknown_command}
    end
  end

  @doc """
  Corre un comando dado
  """

  def run({:insert, data}) do
    Blockchain.insert(Blockchain, data)

    {Blockchain.ReplicatorTask, :"bar@aylen-pc"}
    |> Task.Supervisor.async(Blockchain, :insert, [Blockchain, data])
    |> Task.await

    #{Blockchain.ReplicatorTask, :"foo@aylen-pc"}
    #|> Task.Supervisor.async(Blockchain, :insert_client, [Blockchain, data])
    #|> Task.await

    {:ok, "Ok \r\n"}

  end

  def run({:insert}) do
    Blockchain.insert(Blockchain)

    {Blockchain.ReplicatorTask, :"bar@aylen-pc"}
    |> Task.Supervisor.async(Blockchain, :insert, [Blockchain])
    |> Task.await

    #{Blockchain.ReplicatorTask, :"foo@aylen-pc"}
    #|> Task.Supervisor.async(Blockchain, :insert, [Blockchain])
    #|> Task.await

    {:ok, "Ok \r\n"}
  end
end
