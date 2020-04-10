defmodule Chess.GameMaster do
  use DynamicSupervisor

  def start_link(options \\ []) do
    DynamicSupervisor.start_link(__MODULE__, %{}, options)
  end

  def start_game(game_master \\ __MODULE__, players) do
    name = UUID.uuid4(:hex)
    DynamicSupervisor.start_child(game_master, {Chess.GameSession, {name, players}})

    name
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
