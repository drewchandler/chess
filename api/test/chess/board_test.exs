defmodule Chess.BoardTest do
  alias Chess.{Board, Piece, Position}
  use ExUnit.Case

  test "you can move pieces into empty squares" do
    board = %{
      Position.new(0, 2) => Piece.new(:rook, :white),
      Position.new(0, 5) => Piece.new(:pawn, :black),
      Position.new(4, 0) => Piece.new(:king, :white),
      Position.new(4, 7) => Piece.new(:king, :black)
    }

    new_board = Board.move(board, Position.new(0, 2), Position.new(0, 4))

    assert new_board == %{
             Position.new(0, 4) => Piece.new(:rook, :white),
             Position.new(0, 5) => Piece.new(:pawn, :black),
             Position.new(4, 0) => Piece.new(:king, :white),
             Position.new(4, 7) => Piece.new(:king, :black)
           }
  end

  test "you can move pieces into occupied squares" do
    board = %{
      Position.new(0, 2) => Piece.new(:rook, :white),
      Position.new(0, 5) => Piece.new(:pawn, :black),
      Position.new(4, 0) => Piece.new(:king, :white),
      Position.new(4, 7) => Piece.new(:king, :black)
    }

    new_board = Board.move(board, Position.new(0, 2), Position.new(0, 5))

    assert new_board == %{
             Position.new(0, 5) => Piece.new(:rook, :white),
             Position.new(4, 0) => Piece.new(:king, :white),
             Position.new(4, 7) => Piece.new(:king, :black)
           }
  end

  test "you can ask for the piece at a given position" do
    board = %{
      Position.new(0, 2) => Piece.new(:rook, :white),
      Position.new(0, 5) => Piece.new(:pawn, :black),
      Position.new(4, 0) => Piece.new(:king, :white),
      Position.new(4, 7) => Piece.new(:king, :black)
    }

    result = Board.piece_at(board, Position.new(0, 5))

    assert result == Piece.new(:pawn, :black)
  end

  test "you can ask if a position is occupied" do
    board = %{
      Position.new(0, 2) => Piece.new(:rook, :white),
      Position.new(0, 5) => Piece.new(:pawn, :black),
      Position.new(4, 0) => Piece.new(:king, :white),
      Position.new(4, 7) => Piece.new(:king, :black)
    }

    assert Board.occupied?(board, Position.new(0, 2))
    refute Board.occupied?(board, Position.new(5, 2))
  end

  test "you can ask if a position is occupied by a color" do
    board = %{
      Position.new(0, 2) => Piece.new(:rook, :white),
      Position.new(0, 5) => Piece.new(:pawn, :black),
      Position.new(4, 0) => Piece.new(:king, :white),
      Position.new(4, 7) => Piece.new(:king, :black)
    }

    assert Board.occupied_by_color?(board, Position.new(0, 2), :white)
    refute Board.occupied_by_color?(board, Position.new(0, 2), :black)
    refute Board.occupied_by_color?(board, Position.new(5, 2), :white)
  end
end
