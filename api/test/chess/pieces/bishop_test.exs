defmodule Chess.Pieces.BishopTest do
  use ExUnit.Case
  use MoveHelpers

  alias Chess.{Piece, Pieces.Bishop, Position}

  test "bishops can move diagonally" do
    position = Position.new(3, 5)
    board = %{position => Piece.new(:bishop, :white)}

    moves = Bishop.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(0, 2),
             Position.new(1, 3),
             Position.new(1, 7),
             Position.new(2, 4),
             Position.new(2, 6),
             Position.new(4, 4),
             Position.new(4, 6),
             Position.new(5, 3),
             Position.new(5, 7),
             Position.new(6, 2),
             Position.new(7, 1)
           ]
  end

  test "bishops are blocked by friendly pieces" do
    position = Position.new(3, 5)

    board = %{
      position => Piece.new(:bishop, :white),
      Position.new(1, 3) => Piece.new(:bishop, :white),
      Position.new(1, 7) => Piece.new(:bishop, :white),
      Position.new(5, 3) => Piece.new(:bishop, :white),
      Position.new(5, 7) => Piece.new(:bishop, :white)
    }

    moves = Bishop.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(2, 4),
             Position.new(2, 6),
             Position.new(4, 4),
             Position.new(4, 6)
           ]
  end

  test "bishops are blocked by enemy pieces but they can capture" do
    position = Position.new(3, 5)

    board = %{
      position => Piece.new(:bishop, :white),
      Position.new(1, 3) => Piece.new(:bishop, :black),
      Position.new(1, 7) => Piece.new(:bishop, :black),
      Position.new(5, 3) => Piece.new(:bishop, :black),
      Position.new(5, 7) => Piece.new(:bishop, :black)
    }

    moves = Bishop.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(1, 3),
             Position.new(1, 7),
             Position.new(2, 4),
             Position.new(2, 6),
             Position.new(4, 4),
             Position.new(4, 6),
             Position.new(5, 3),
             Position.new(5, 7)
           ]
  end
end
