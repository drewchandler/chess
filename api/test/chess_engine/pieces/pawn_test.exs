defmodule ChessEngine.Pieces.PawnTest do
  use ExUnit.Case

  alias ChessEngine.{Piece, Pieces.Pawn, Position}

  test "white pawns can move up one space" do
    position = Position.new(0, 5)

    board = %{
      position => Piece.new(:pawn, :white)
    }

    assert Pawn.moves(board, :white, position) == [Position.new(0, 6)]
  end

  test "white pawns can move up two spaces on the second row" do
    position = Position.new(0, 1)

    board = %{
      position => Piece.new(:pawn, :white)
    }

    assert Pawn.moves(board, :white, position) == [Position.new(0, 2), Position.new(0, 3)]
  end

  test "black pawns can move down one space" do
    position = Position.new(0, 5)

    board = %{
      position => Piece.new(:pawn, :black)
    }

    assert Pawn.moves(board, :black, position) == [Position.new(0, 4)]
  end

  test "black pawns can move down two spaces on the seventh row" do
    position = Position.new(0, 6)

    board = %{
      position => Piece.new(:pawn, :black)
    }

    assert Pawn.moves(board, :black, position) == [Position.new(0, 5), Position.new(0, 4)]
  end

  test "pawns cannot move forward into an occupied space" do
    position = Position.new(0, 2)

    board = %{
      position => Piece.new(:pawn, :white),
      Position.new(0, 3) => Piece.new(:pawn, :white)
    }

    assert Pawn.moves(board, :white, position) == []
  end

  test "pawns cannot move two spaces over an occupied space" do
    position = Position.new(0, 1)

    board = %{
      position => Piece.new(:pawn, :white),
      Position.new(0, 2) => Piece.new(:pawn, :white)
    }

    assert Pawn.moves(board, :white, position) == []
  end

  test "pawns cannot move two spaces into an occupied space" do
    position = Position.new(0, 1)

    board = %{
      position => Piece.new(:pawn, :white),
      Position.new(0, 3) => Piece.new(:pawn, :white)
    }

    assert Pawn.moves(board, :white, position) == [Position.new(0, 2)]
  end

  test "pawns can capture diagonally" do
    position = Position.new(0, 5)
    opponent_position = Position.new(1, 6)

    board = %{
      position => Piece.new(:pawn, :white),
      opponent_position => Piece.new(:pawn, :black)
    }

    assert Pawn.moves(board, :white, position) == [Position.new(0, 6), opponent_position]
  end

  test "pawns cannot capture pieces of the same color" do
    position = Position.new(0, 5)

    board = %{
      position => Piece.new(:pawn, :white),
      Position.new(1, 6) => Piece.new(:pawn, :white)
    }

    assert Pawn.moves(board, :white, position) == [Position.new(0, 6)]
  end
end
