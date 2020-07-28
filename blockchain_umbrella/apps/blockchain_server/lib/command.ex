defmodule BlockchainServer.Command do
  @doc ~S"""
    Parsea la lina dada a un comando
    ##Ejemplo
        iex> BlockchainServer.Command.parse("CREATE shopping\r\n")
        {:ok, {:create, "shopping"}}
  """

  def parse(_line) do
    :not_implemented
  end
end
