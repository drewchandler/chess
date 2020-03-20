defmodule ChessWeb.MatchmakingChannel do
  use ChessWeb, :channel

  def join("matchmaking:" <> username, _payload, socket) do
    Chess.MatchmakingQueue.join(username)

    {:ok, socket}
  end

  def terminate(_reason, socket) do
    socket.topic
    |> username_from_topic()
    |> Chess.MatchmakingQueue.leave()

    :ok
  end

  defp username_from_topic("matchmaking:" <> username), do: username

  defmodule MatchBroadcaster do
    use GenStage

    def start_link(producer, options \\ []) do
      GenStage.start_link(__MODULE__, producer, options)
    end

    def init(producer) do
      {:consumer, :ok, subscribe_to: [producer]}
    end

    def handle_events(events, _from, state) do
      for event <- events do
        for player <- event.players do
          ChessWeb.Endpoint.broadcast!("matchmaking:" <> player, "matched", event)
        end
      end

      {:noreply, [], state}
    end
  end
end
