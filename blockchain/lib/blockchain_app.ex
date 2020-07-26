defmodule BlockchainApp do

  use Application

  @impl true
  def start(_type, _args) do
    BlockchainSupervisor.start_link(name: BlockchainSupervisor)
  end
end
