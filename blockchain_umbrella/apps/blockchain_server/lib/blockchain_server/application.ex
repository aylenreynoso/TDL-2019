defmodule BlockchainServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  #PORT=4321 mix run --no-halt
  def start(_type, _args) do

    port = String.to_integer(System.get_env("PORT") || "4040")
    children = [
      #{Task.Supervisor, name: BlockchainServer.TaskSupervisor}, #supervisor 1:1 build-in de Task
      {Task, fn -> BlockchainServer.accept(port) end}
    ]

    opts = [strategy: :one_for_one, name: BlockchainServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
