defmodule ChessEngine.Pieces.PawnTest do
  use ExUnit.Case

  alias ChessEngine.{Piece, Pieces.Pawn, Position}

  test "white pawns can move up one space" do
    position = %Position{x: 0, y: 5}

    board = %{
      position => %Piece{type: :pawn, color: :white}
    }

    assert Pawn.moves(board, :white, position) == [%Position{x: 0, y: 6}]
  end

  test "white pawns can move up two spaces on the second row" do
    position = %Position{x: 0, y: 1}

    board = %{
      position => %Piece{type: :pawn, color: :white}
    }

    assert Pawn.moves(board, :white, position) == [%Position{x: 0, y: 2}, %Position{x: 0, y: 3}]
  end

  test "black pawns can move down one space" do
    position = %Position{x: 0, y: 5}

    board = %{
      position => %Piece{type: :pawn, color: :black}
    }

    assert Pawn.moves(board, :black, position) == [%Position{x: 0, y: 4}]
  end

  test "black pawns can move down two spaces on the seventh row" do
    position = %Position{x: 0, y: 6}

    board = %{
      position => %Piece{type: :pawn, color: :black}
    }

    assert Pawn.moves(board, :black, position) == [%Position{x: 0, y: 5}, %Position{x: 0, y: 4}]
  end

  test "pawns cannot move forward into an occupied space" do
    position = %Position{x: 0, y: 2}

    board = %{
      position => %Piece{type: :pawn, color: :white},
      %Position{x: 0, y: 3} => %Piece{type: :pawn, color: :white}
    }

    assert Pawn.moves(board, :white, position) == []
  end

  test "pawns cannot move two spaces over an occupied space" do
    position = %Position{x: 0, y: 1}

    board = %{
      position => %Piece{type: :pawn, color: :white},
      %Position{x: 0, y: 2} => %Piece{type: :pawn, color: :white}
    }

    assert Pawn.moves(board, :white, position) == []
  end

  test "pawns cannot move two spaces into an occupied space" do
    position = %Position{x: 0, y: 1}

    board = %{
      position => %Piece{type: :pawn, color: :white},
      %Position{x: 0, y: 3} => %Piece{type: :pawn, color: :white}
    }

    assert Pawn.moves(board, :white, position) == [%Position{x: 0, y: 2}]
  end

  test "pawns can capture diagonally" do
    position = %Position{x: 0, y: 5}
    opponent_position = %Position{x: 1, y: 6}

    board = %{
      position => %Piece{type: :pawn, color: :white},
      opponent_position => %Piece{type: :pawn, color: :black}
    }

    assert Pawn.moves(board, :white, position) == [%Position{x: 0, y: 6}, opponent_position]
  end

  test "pawns cannot capture pieces of the same color" do
    position = %Position{x: 0, y: 5}

    board = %{
      position => %Piece{type: :pawn, color: :white},
      %Position{x: 1, y: 6} => %Piece{type: :pawn, color: :white}
    }

    assert Pawn.moves(board, :white, position) == [%Position{x: 0, y: 6}]
  end
end
