defmodule Chess.MatchmakingQueue do
  use GenServer

  defmodule Player do
    @enforce_keys [:name, :join_callback]
    defstruct [:name, :join_callback]

    def new(name, join_callback), do: %__MODULE__{name: name, join_callback: join_callback}
  end

  def start_link(game_master, options \\ []) do
    GenServer.start_link(__MODULE__, game_master, options)
  end

  def join(queue \\ __MODULE__, player_name, join_callback) do
    GenServer.call(queue, {:join, Player.new(player_name, join_callback)})
  end

  def leave(queue \\ __MODULE__, player_name) do
    GenServer.call(queue, {:leave, player_name})
  end

  def init(game_master) do
    {:ok, %{game_master: game_master, waiting_player: nil}}
  end

  def handle_call(
        {:join, %{name: already_waiting_player}},
        _from,
        state = %{waiting_player: %{name: already_waiting_player}}
      ) do
    {:reply, {:error, "Already in the queue"}, state}
  end

  def handle_call({:join, player}, _from, state = %{waiting_player: nil}) do
    {:reply, :ok, %{state | waiting_player: player}}
  end

  def handle_call(
        {:join, new_player},
        _from,
        %{game_master: game_master, waiting_player: waiting_player}
      ) do
    game_name = game_master.start_game([new_player.name, waiting_player.name])
    new_player.join_callback.(game_name)
    waiting_player.join_callback.(game_name)

    {:reply, :ok, %{game_master: game_master, waiting_player: nil}}
  end

  def handle_call({:leave, player_name}, _from, state = %{waiting_player: %{name: player_name}}) do
    {:reply, :ok, %{state | waiting_player: nil}}
  end

  def handle_call({:leave, _player_name}, _from, state) do
    {:reply, :ok, state}
  end
end
