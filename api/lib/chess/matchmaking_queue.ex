defmodule Chess.MatchmakingQueue do
  use GenServer

  def start_link(options \\ []) do
    GenStage.start_link(__MODULE__, :ok, options)
  end

  def join(queue \\ __MODULE__, player) do
    GenServer.call(queue, {:join, player})
  end

  def leave(queue \\ __MODULE__, player) do
    GenServer.call(queue, {:leave, player})
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:join, player}, _from, player) do
    {:reply, :ok, player}
  end

  def handle_call({:join, player}, _from, nil) do
    {:reply, :ok, player}
  end

  def handle_call({:join, _player}, _from, _waiting_player) do
    # [[waiting_player, player]],
    {:reply, :ok, nil}
  end

  def handle_call({:leave, player}, _from, player) do
    {:reply, :ok, nil}
  end

  def handle_call({:leave, _player}, _from, waiting_player) do
    {:reply, :ok, waiting_player}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
