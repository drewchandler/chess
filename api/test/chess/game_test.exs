defmodule Chess.GameTest do
  use ExUnit.Case
  use GameBuilders

  test "you cannot move a nonexistent piece" do
    from = Position.new(0, 5)
    to = Position.new(0, 6)

    game = build_game()

    assert Game.move(game, "white", from, to) ==
             {:error, "There is not a piece in that position."}
  end

  test "you cannot move another players piece" do
    from = Position.new(0, 5)
    to = Position.new(0, 6)

    board = %{
      from => Piece.new(:pawn, :black)
    }

    game = build_game(board: board)

    assert Game.move(game, "white", from, to) ==
             {:error, "That piece does not belong to you."}
  end

  test "you can not move when it is not your turn" do
    from = Position.new(0, 5)
    to = Position.new(0, 6)

    board = %{
      from => Piece.new(:pawn, :black)
    }

    game = build_game(board: board)

    assert Game.move(game, "black", from, to) ==
             {:error, "It is not your turn."}
  end

  test "when a valid move is made, the board is updated and the turn is passed to the other player" do
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
end
