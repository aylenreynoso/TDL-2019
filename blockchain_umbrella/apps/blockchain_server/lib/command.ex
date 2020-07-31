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
      _ -> {:error, :unknown_command}
    end
  end

  @doc """
  Corre un comando dado
  """

  def run({:insert, data}) do
    Blockchain.insert_client(Blockchain, data)
    {:ok, "Ok \r\n"}

  end
end
