defmodule Chess.Pieces.RookTest do
  use ExUnit.Case
  use MoveHelpers

  alias Chess.{Piece, Pieces.Rook, Position}

  test "rooks can move horizontally and vertically" do
    position = Position.new(3, 5)
    board = %{position => Piece.new(:rook, :white)}

    moves = Rook.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(0, 5),
             Position.new(1, 5),
             Position.new(2, 5),
             Position.new(3, 0),
             Position.new(3, 1),
             Position.new(3, 2),
             Position.new(3, 3),
             Position.new(3, 4),
             Position.new(3, 6),
             Position.new(3, 7),
             Position.new(4, 5),
             Position.new(5, 5),
             Position.new(6, 5),
             Position.new(7, 5)
           ]
  end

  test "rooks are blocked by friendly pieces" do
    position = Position.new(3, 5)

    board = %{
      position => Piece.new(:rook, :white),
      Position.new(1, 5) => Piece.new(:rook, :white),
      Position.new(5, 5) => Piece.new(:rook, :white),
      Position.new(3, 1) => Piece.new(:rook, :white),
      Position.new(3, 6) => Piece.new(:rook, :white)
    }

    moves = Rook.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(2, 5),
             Position.new(3, 2),
             Position.new(3, 3),
             Position.new(3, 4),
             Position.new(4, 5)
           ]
  end

  test "rooks are blocked by enemy pieces but they can capture" do
    position = Position.new(3, 5)

    board = %{
      position => Piece.new(:rook, :white),
      Position.new(1, 5) => Piece.new(:rook, :black),
      Position.new(5, 5) => Piece.new(:rook, :black),
      Position.new(3, 1) => Piece.new(:rook, :black),
      Position.new(3, 6) => Piece.new(:rook, :black)
    }

    moves = Rook.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(1, 5),
             Position.new(2, 5),
             Position.new(3, 1),
             Position.new(3, 2),
             Position.new(3, 3),
             Position.new(3, 4),
             Position.new(3, 6),
             Position.new(4, 5),
             Position.new(5, 5)
           ]
  end
end
