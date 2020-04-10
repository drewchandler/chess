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

  def move(name, player, from, to) do
    GenServer.call(via(name), {:move, player, from, to})
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
      {:ok, new_game} -> {:reply, {:ok, new_game}, new_game}
      error -> {:reply, error, game}
    end
  end

  def handle_call(:current_state, _from, game) do
    {:reply, game, game}
  end
end
