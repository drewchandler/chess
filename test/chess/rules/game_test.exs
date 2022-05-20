defmodule Chess.Rules.GameTest do
  use ExUnit.Case
  use GameBuilders

  describe "move/4" do
    test "you cannot move a nonexistent piece" do
      from = Position.new(0, 5)
      to = Position.new(0, 6)

      game = build_game()

      assert Game.move(game, "white", from, to) ==
               {:error, "There is not a piece in that position."}
    end

    test "white cannot move the black player's piece" do
      from = Position.new(0, 5)
      to = Position.new(0, 6)

      board = %{
        from => Piece.new(:pawn, :black)
      }

      game = build_game(board: board)

      assert Game.move(game, "white", from, to) ==
               {:error, "That piece does not belong to you."}
    end

    test "black cannot move the white player's piece" do
      from = Position.new(0, 5)
      to = Position.new(0, 6)

      board = %{
        from => Piece.new(:pawn, :white)
      }

      game = build_game(board: board, state: :black_turn)

      assert Game.move(game, "black", from, to) ==
               {:error, "That piece does not belong to you."}
    end

    test "black can not move when it is not their turn" do
      from = Position.new(0, 5)
      to = Position.new(0, 6)

      board = %{
        from => Piece.new(:pawn, :black)
      }

      game = build_game(board: board)

      assert Game.move(game, "black", from, to) ==
               {:error, "It is not your turn."}
    end

    test "white can not move when it is not their turn" do
      from = Position.new(0, 5)
      to = Position.new(0, 6)

      board = %{
        from => Piece.new(:pawn, :white)
      }

      game = build_game(board: board, state: :black_turn)

      assert Game.move(game, "white", from, to) ==
               {:error, "It is not your turn."}
    end

    test "when white makes a valid move, the board is updated and the turn is passed to the black player" do
      from = Position.new(0, 5)
      to = Position.new(0, 6)

      board = %{
        from => Piece.new(:pawn, :white),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      game = build_game(board: board)

      assert Game.move(game, "white", from, to) ==
               {:ok,
                %{
                  game
                  | state: :black_turn,
                    board: %{
                      to => Piece.new(:pawn, :white),
                      Position.new(4, 0) => Piece.new(:king, :white),
                      Position.new(4, 7) => Piece.new(:king, :black)
                    }
                }}
    end

    test "when black makes a valid move, the board is updated and the turn is passed to the white player" do
      from = Position.new(0, 6)
      to = Position.new(0, 5)

      board = %{
        from => Piece.new(:pawn, :black),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      game = build_game(board: board, state: :black_turn)

      assert Game.move(game, "black", from, to) ==
               {:ok,
                %{
                  game
                  | state: :white_turn,
                    board: %{
                      to => Piece.new(:pawn, :black),
                      Position.new(4, 0) => Piece.new(:king, :white),
                      Position.new(4, 7) => Piece.new(:king, :black)
                    }
                }}
    end
  end

  describe "done?/1" do
    test "it is true if white has won" do
      game = build_game(state: :white_victory)

      assert Game.done?(game)
    end

    test "it is true if black has won" do
      game = build_game(state: :black_victory)

      assert Game.done?(game)
    end

    test "it is false if it is white's turn" do
      game = build_game(state: :white_turn)

      refute Game.done?(game)
    end

    test "it is false if it is black's turn" do
      game = build_game(state: :black_turn)

      refute Game.done?(game)
    end
  end

  describe "legal_moves/2" do
    test "is returns a list of legal moves from the given position" do
      game = build_game()
      position = Position.new(1, 1)

      assert Game.legal_moves(game, position) ==
               [%Position{x: 1, y: 2}, %Position{x: 1, y: 3}]
    end
  end

  describe "color_for_player/2" do
    test "it returns the color for the white player" do
      game = build_game()

      assert Game.color_for_player(game, "white") == {:ok, :white}
    end

    test "it returns the color for the black player" do
      game = build_game()

      assert Game.color_for_player(game, "black") == {:ok, :black}
    end

    test "it returns an error if the player is not in the game" do
      game = build_game()

      assert Game.color_for_player(game, "not in game") ==
               {:error, "'not in game' is not a player in this game."}
    end
  end

  describe "active_player/1" do
    test "it returns the white players name if it is white's turn" do
      game = build_game()

      assert Game.active_player(game) == "white"
    end

    test "it returns the black players name if it is black's turn" do
      game = build_game(state: :black_turn)

      assert Game.active_player(game) == "black"
    end

    test "it returns nil if white has won" do
      game = build_game(state: :white_victory)

      refute Game.active_player(game)
    end

    test "it returns nil if black has won" do
      game = build_game(state: :black_victory)

      refute Game.active_player(game)
    end
  end

  describe "winning_player/1" do
    test "it returns the white players name if white has won" do
      game = build_game(state: :white_victory)

      assert Game.winning_player(game) == "white"
    end

    test "it returns the black players name if black has won" do
      game = build_game(state: :black_victory)

      assert Game.winning_player(game) == "black"
    end

    test "it returns nil if it is white's turn" do
      game = build_game()

      refute Game.winning_player(game)
    end

    test "it returns nil if it is black's turn" do
      game = build_game(state: :black_turn)

      refute Game.winning_player(game)
    end
  end
end
