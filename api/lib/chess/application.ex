defmodule Chess.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      ChessWeb.Endpoint,
      {Registry, [name: Chess.Registry.GameSession, keys: :unique]},
      {DynamicSupervisor, [name: Chess.Supervisor.GameSession, strategy: :one_for_one]},
      {Chess.MatchmakingQueue, [name: Chess.MatchmakingQueue]},
      %{
        id: Chess.GameFactory,
        start:
          {Chess.GameFactory, :start_link, [Chess.MatchmakingQueue, [name: Chess.GameFactory]]}
      },
      %{
        id: ChessWeb.MatchmakingChannel.MatchBroadcaster,
        start:
          {ChessWeb.MatchmakingChannel.MatchBroadcaster, :start_link,
           [Chess.GameFactory, [name: ChessWeb.MatchmakingChannel.MatchBroadcaster]]}
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
