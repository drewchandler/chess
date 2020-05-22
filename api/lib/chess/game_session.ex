defmodule Chess.GameSession do
  alias Chess.Game

  use GenServer

  def child_spec({name, players}) do
    %{
      id: {__MODULE__, name},
      start: {__MODULE__, :start_link, [{name, players}]},
      restart: :temporary
    }
  end

  def start_link({name, players}) do
    GenServer.start_link(__MODULE__, players, name: via(name))
  end

  def via(name) do
    {:via, Registry, {Chess.Registry.GameSession, name}}
  end

  def exists?(name) do
    case List.first(Registry.lookup(Chess.Registry.GameSession, name)) do
      nil -> false
      {pid, _value} -> Process.alive?(pid)
    end
  end

  def move(name, player, from, to) do
    GenServer.call(via(name), {:move, player, from, to})
  end

  def legal_moves(name, position) do
    GenServer.call(via(name), {:legal_moves, position})
  end

  def current_state(name) do
    GenServer.call(via(name), :current_state)
  end

  def init(players) do
    players
    |> Enum.shuffle()
    |> (&{:ok, Game.new(players: &1)}).()
  end

  def handle_call({:move, player, from, to}, _from, game) do
    case Game.move(game, player, from, to) do
      {:ok, new_game} ->
        if Game.done?(new_game) do
          {:stop, "Game over", {:ok, new_game}, new_game}
        else
          {:reply, {:ok, new_game}, new_game}
        end

      error ->
        {:reply, error, game}
    end
  end

  def handle_call({:legal_moves, position}, _from, game) do
    moves = Game.legal_moves(game, position)

    {:reply, {:ok, moves}, game}
  end

  def handle_call(:current_state, _from, game) do
    {:reply, game, game}
  end
end
