defmodule Chess.GameSessionTest do
  use ExUnit.Case

  alias Chess.GameSession
  alias Chess.Rules.{Game, Position}

  @name "name"
  @player1 "player1"
  @player2 "player2"

  setup do
    {:ok, pid} = start_supervised({GameSession, {@name, [@player1, @player2]}})

    [pid: pid]
  end

  describe "exists?/1" do
    test "is true when a game exists for the given name" do
      assert GameSession.exists?(@name)
    end

    test "is false when a game does not exists for the given name" do
      refute GameSession.exists?("no-game")
    end
  end

  describe "current_state/1" do
    test "returns the current state of the game" do
      state = GameSession.current_state(@name)

      assert state.board == Chess.Rules.Board.initial_board()
      assert state.state == :white_turn
      assert Enum.member?(state.players, @player1)
      assert Enum.member?(state.players, @player2)
    end
  end

  describe "move/4" do
    test "updates the game when the move is legal" do
      initial_game = GameSession.current_state(@name)
      white = Game.active_player(initial_game)
      from = Position.new(0, 1)
      to = Position.new(0, 2)

      move_result = GameSession.move(@name, white, from, to)

      assert move_result == Game.move(initial_game, white, from, to)
    end

    test "returns an error when the move is illegal" do
      initial_game = GameSession.current_state(@name)
      white = Game.active_player(initial_game)

      assert GameSession.move(@name, white, Position.new(5, 5), Position.new(6, 6)) ==
               {:error, "There is not a piece in that position."}
    end

    @tag capture_log: true
    test "exits when the game is over", %{pid: pid} do
      Process.monitor(pid)

      initial_game = GameSession.current_state(@name)
      [white, black] = initial_game.players

      {:ok, _} = GameSession.move(@name, white, Position.new(6, 1), Position.new(6, 3))
      {:ok, _} = GameSession.move(@name, black, Position.new(4, 6), Position.new(4, 5))
      {:ok, _} = GameSession.move(@name, white, Position.new(5, 1), Position.new(5, 2))
      {:ok, _} = GameSession.move(@name, black, Position.new(3, 7), Position.new(7, 3))

      assert_receive {:DOWN, _, _, ^pid, "Game over"}
    end
  end
end
