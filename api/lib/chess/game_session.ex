defmodule Chess.GameSession do
  alias Chess.Game

  use GenServer

  def init(players) do
    players
    |> Enum.shuffle()
    |> (&{:ok, Game.new(players: &1)}).()
  end

  def handle_call({:move, player, from, to}, _from, game) do
    case Game.move(game, player, from, to) do
      {:ok, new_game} -> {:reply, {:ok, new_game}, new_game}
      error -> {:reply, error, game}
    end
  end

  def handle_call(:current_state, _from, game) do
    {:reply, game, game}
  end

  def move(session, player, from, to) do
    GenServer.call(session, {:move, player, from, to})
  end

  def current_state(session) do
    GenServer.call(session, :current_state)
  end
end
