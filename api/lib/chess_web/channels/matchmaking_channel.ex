defmodule ChessWeb.MatchmakingChannel do
  use ChessWeb, :channel

  def join("matchmaking:" <> username, _payload, socket) do
    Chess.MatchmakingQueue.join(username, fn game_name ->
      ChessWeb.Endpoint.broadcast!(socket.topic, "matched", %{name: game_name})
    end)

    {:ok, socket}
  end

  def terminate(_reason, socket) do
    socket.topic
    |> username_from_topic()
    |> Chess.MatchmakingQueue.leave()

    :ok
  end

  defp username_from_topic("matchmaking:" <> username), do: username
end
