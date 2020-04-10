defmodule Chess.MatchmakingQueue do
  use GenServer

  def start_link(game_master, options \\ []) do
    GenServer.start_link(__MODULE__, game_master, options)
  end

  def join(queue \\ __MODULE__, player_name, callback) do
    GenServer.call(queue, {:join, player_name, callback})
  end

  def leave(queue \\ __MODULE__, player_name) do
    GenServer.call(queue, {:leave, player_name})
  end

  def init(game_master) do
    {:ok, %{game_master: game_master, waiting_player: nil}}
  end

  def handle_call(
        {:join, player_name, callback},
        _from,
        state = %{waiting_player: {player_name, _}}
      ) do
    {:reply, :ok, %{state | waiting_player: {player_name, callback}}}
  end

  def handle_call({:join, player, callback}, _from, state = %{waiting_player: nil}) do
    {:reply, :ok, %{state | waiting_player: {player, callback}}}
  end

  def handle_call(
        {:join, player_name, callback},
        _from,
        %{game_master: game_master, waiting_player: {waiting_player_name, waiting_callback}}
      ) do
    game_name = game_master.start_game([player_name, waiting_player_name])
    callback.(game_name)
    waiting_callback.(game_name)

    {:reply, :ok, %{game_master: game_master, waiting_player: nil}}
  end

  def handle_call({:leave, player_name}, _from, state = %{waiting_player: {player_name, _}}) do
    {:reply, :ok, %{state | waiting_player: nil}}
  end

  def handle_call({:leave, _player_name}, _from, state) do
    {:reply, :ok, state}
  end
end
