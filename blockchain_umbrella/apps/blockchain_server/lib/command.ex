defmodule BlockchainServer.Command do
  @doc ~S"""
    Parsea la lina dada a un comando
    ##Ejemplo
        iex> BlockchainServer.Command.parse("CREATE data\r\n")
        {:ok, {:create, "data"}}
  """

  def parse(line) do
    case String.split(line)do
      ["CREATE", data] -> {:ok, {:create, data}}
      _ -> {:error, :unknown_command}
    end
  end

  @doc """
  Corre un comando dado
  """

  def run(command) do
    {:ok, "Ok \r\n"}

  end
end
