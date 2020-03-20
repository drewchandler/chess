defmodule Chess.MatchmakingQueue do
  use GenStage

  def start_link(options \\ []) do
    GenStage.start_link(__MODULE__, :ok, options)
  end

  def join(queue \\ __MODULE__, player) do
    GenStage.call(queue, {:join, player})
  end

  def leave(queue \\ __MODULE__, player) do
    GenStage.call(queue, {:leave, player})
  end

  def init(_) do
    {:producer, nil}
  end

  def handle_call({:join, player}, _from, player) do
    {:reply, :ok, [], player}
  end

  def handle_call({:join, player}, _from, nil) do
    {:reply, :ok, [], player}
  end

  def handle_call({:join, player}, _from, waiting_player) do
    {:reply, :ok, [[waiting_player, player]], nil}
  end

  def handle_call({:leave, player}, _from, player) do
    {:reply, :ok, [], nil}
  end

  def handle_call({:leave, _player}, _from, waiting_player) do
    {:reply, :ok, [], waiting_player}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
