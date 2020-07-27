defmodule BlockchainSever.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: BlockchainSever.Worker.start_link(arg)
      # {BlockchainSever.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: BlockchainSever.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
