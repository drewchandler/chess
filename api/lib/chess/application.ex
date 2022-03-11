defmodule Chess.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      ChessWeb.Endpoint,
      {Phoenix.PubSub, name: Chess.PubSub},
      {Registry, [name: Chess.Registry.GameSession, keys: :unique]},
      {Chess.GameMaster, [name: Chess.GameMaster]},
      %{
        id: Chess.MatchmakingQueue,
        start:
          {Chess.MatchmakingQueue, :start_link,
           [Chess.GameMaster, [name: Chess.MatchmakingQueue]]}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chess.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ChessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
