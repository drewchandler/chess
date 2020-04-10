defmodule Chess.GameMaster do
  use DynamicSupervisor

  def start_link(opts \\ [name: __MODULE__]) do
    DynamicSupervisor.start_link(__MODULE__, %{}, opts)
  end

  def start_game(master \\ __MODULE__, players) do
    name = UUID.uuid4(:hex)

    DynamicSupervisor.start_child(master, {GameSession, {name, players}})
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
    DynamicSupervisor.start_child(self(), {MatchmakingQueue, name: MatchmakingQueue})
  end
end
