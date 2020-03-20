defmodule Chess.MatchmakingQueueTest do
  alias Chess.MatchmakingQueue

  use ExUnit.Case

  defmodule TestConsumer do
    def start_link(producer) do
      GenStage.start_link(__MODULE__, {producer, self()})
    end

    def init({producer, owner}) do
      {:consumer, owner, subscribe_to: [producer]}
    end

    def handle_events(events, _from, owner) do
      send(owner, {:received, events})
      {:noreply, [], owner}
    end
  end

  test "joining an empty queue does not start a match" do
    {:ok, queue} = MatchmakingQueue.start_link()
    {:ok, _} = TestConsumer.start_link(queue)

    MatchmakingQueue.join(queue, "player")

    refute_receive {:received, _}
  end

  test "joining queue with another player in it pairs you with the other player" do
    {:ok, queue} = MatchmakingQueue.start_link()
    {:ok, _} = TestConsumer.start_link(queue)

    MatchmakingQueue.join(queue, "player1")
    MatchmakingQueue.join(queue, "player2")

    assert_receive {:received, [["player1", "player2"]]}
  end

  test "joining twice doesn't start a match" do
    {:ok, queue} = MatchmakingQueue.start_link()
    {:ok, _} = TestConsumer.start_link(queue)

    MatchmakingQueue.join(queue, "player")
    MatchmakingQueue.join(queue, "player")

    refute_receive {:received, _}
  end

  test "leaving the queue" do
    {:ok, queue} = MatchmakingQueue.start_link()
    {:ok, _} = TestConsumer.start_link(queue)

    MatchmakingQueue.join(queue, "player1")
    MatchmakingQueue.leave(queue, "player1")
    MatchmakingQueue.join(queue, "player2")

    refute_receive {:received, _}
  end
end
