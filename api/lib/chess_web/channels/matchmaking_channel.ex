defmodule ChessWeb.MatchmakingChannel do
  use ChessWeb, :channel

  def join("matchmaking:" <> _username, _payload, socket) do
    me = self()

    Chess.MatchmakingQueue.join(username_from_topic(socket.topic), fn game_name ->
      send(me, {:matched, game_name})
    end)
    |> case do
      :ok -> {:ok, socket}
      {:error, error} -> {:error, %{message: error}}
    end
  end

  @spec handle_info({:matched, any}, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_info({:matched, game_name}, socket) do
    broadcast!(socket, "matched", %{name: game_name})

    {:noreply, socket}
  end

  def terminate({:shutdown, _}, socket) do
    socket.topic
    |> username_from_topic()
    |> Chess.MatchmakingQueue.leave()

    :ok
  end

  def terminate(_reason, _socket) do
    :ok
  end

  defp username_from_topic("matchmaking:" <> username), do: username
end
