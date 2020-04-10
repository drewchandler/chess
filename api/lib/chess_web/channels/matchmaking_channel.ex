defmodule ChessWeb.MatchmakingChannel do
  use ChessWeb, :channel

  def join("matchmaking:" <> _username, _payload, socket) do
    send(self(), :after_join)

    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Chess.MatchmakingQueue.join(username_from_topic(socket.topic), fn game_name ->
      broadcast!(socket, "matched", %{name: game_name})
    end)

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    socket.topic
    |> username_from_topic()
    |> Chess.MatchmakingQueue.leave()

    :ok
  end

  defp username_from_topic("matchmaking:" <> username), do: username
end
