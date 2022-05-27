defmodule Chess.MatchmakingQueueTest do
  alias Chess.MatchmakingQueue

  use ExUnit.Case

  defmodule TestGameMaster do
    def start_game(players) do
      Enum.join(players, ",")
    end
  end

  setup do
    me = self()
    join_callback = fn game_name -> send(me, {:received, game_name}) end
    {:ok, queue} = MatchmakingQueue.start_link(TestGameMaster)

    [join_callback: join_callback, queue: queue]
  end

  test "joining an empty queue does not start a match", context do
    join_result = MatchmakingQueue.join(context[:queue], "player", context[:join_callback])

    assert join_result == :ok
    refute_receive {:received, _}
  end

  test "joining queue with another player in it pairs you with the other player", context do
    MatchmakingQueue.join(context[:queue], "player1", context[:join_callback])

    join_result = MatchmakingQueue.join(context[:queue], "player2", context[:join_callback])

    assert join_result == :ok
    assert_receive {:received, "player2,player1"}
    assert_receive {:received, "player2,player1"}
  end

  test "joining twice is an error", context do
    MatchmakingQueue.join(context[:queue], "player", context[:join_callback])

    join_result = MatchmakingQueue.join(context[:queue], "player", context[:join_callback])

    assert join_result == {:error, "Already in the queue"}
  end

  test "leaving the queue, removes the player from the queue", context do
    MatchmakingQueue.join(context[:queue], "player1", context[:join_callback])
    MatchmakingQueue.leave(context[:queue], "player1")
    MatchmakingQueue.join(context[:queue], "player2", context[:join_callback])

    refute_receive {:received, _}
  end

  test "leaving the queue when not actually in the queue does not error", context do
    assert MatchmakingQueue.leave(context[:queue], "player1") == :ok
  end
end
