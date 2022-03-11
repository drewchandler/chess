defmodule Chess.GameSession do
  alias Chess.Game
  alias Phoenix.PubSub

  use GenServer

  def child_spec({name, players}) do
    %{
      id: {__MODULE__, name},
      start: {__MODULE__, :start_link, [{name, players}]},
      restart: :temporary
    }
  end

  def start_link({name, players}) do
    GenServer.start_link(__MODULE__, %{name: name, players: players}, name: via(name))
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

  def subscribe(name) do
    PubSub.subscribe(Chess.PubSub, name)
  end

  def init(%{players: players, name: name}) do
    game =
      players
      |> Enum.shuffle()
      |> (&Game.new(players: &1, clocks: [600_000, 600_000])).()

    timer = timer_for_active_player(game)

    {:ok, %{game: game, timer: timer, name: name}}
  end

  def handle_call(
        {:move, player, from, to},
        _from,
        state = %{game: game, timer: timer, name: name}
      ) do
    case Game.move(game, player, from, to) do
      {:ok, new_game} ->
        if Game.done?(new_game) do
          Process.cancel_timer(timer)
          PubSub.broadcast(Chess.PubSub, name, {:game_update, new_game})
          {:stop, "Game over", {:ok, new_game}, %{state | game: new_game}}
        else
          remaining_time =
            case Process.cancel_timer(timer) do
              t when is_integer(t) -> t
              _ -> 0
            end

          new_game = Game.set_clock(new_game, player, remaining_time)

          if Game.done?(new_game) do
            PubSub.broadcast(Chess.PubSub, name, {:game_update, new_game})
            {:stop, "Game over", {:ok, new_game}, %{state | game: new_game}}
          else
            PubSub.broadcast(Chess.PubSub, name, {:game_update, new_game})
            new_timer = timer_for_active_player(new_game)
            {:reply, {:ok, new_game}, %{state | game: new_game, timer: new_timer}}
          end
        end

      error ->
        {:reply, error, state}
    end
  end

  def handle_call({:legal_moves, position}, _from, state = %{game: game}) do
    moves = Game.legal_moves(game, position)

    {:reply, {:ok, moves}, state}
  end

  def handle_call(:current_state, _from, state = %{game: game}) do
    {:reply, game, state}
  end

  def handle_info(
        :white_timeout,
        state = %{game: game = %{players: [white_player, _]}, name: name}
      ) do
    new_game = Game.set_clock(game, white_player, 0)
    PubSub.broadcast(Chess.PubSub, name, {:game_update, new_game})

    {:stop, "Game over", %{state | game: new_game}}
  end

  def handle_info(
        :black_timeout,
        state = %{game: game = %{players: [_, black_player]}, name: name}
      ) do
    new_game = Game.set_clock(game, black_player, 0)
    PubSub.broadcast(Chess.PubSub, name, {:game_update, new_game})

    {:stop, "Game over", %{state | game: new_game}}
  end

  defp timer_for_active_player(%{state: :white_turn, clocks: [remaining_time, _]}) do
    Process.send_after(self(), :white_timeout, remaining_time)
  end

  defp timer_for_active_player(%{state: :black_turn, clocks: [_, remaining_time]}) do
    Process.send_after(self(), :black_timeout, remaining_time)
  end
end
