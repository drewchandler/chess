defmodule Chess.Pieces.KnightTest do
  use ExUnit.Case
  use MoveHelpers

  alias Chess.{Piece, Pieces.Knight, Position}

  test "knights can move in an L shape" do
    position = Position.new(3, 5)
    board = %{position => Piece.new(:knight, :white)}

    moves = Knight.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(1, 4),
             Position.new(1, 6),
             Position.new(2, 3),
             Position.new(2, 7),
             Position.new(4, 3),
             Position.new(4, 7),
             Position.new(5, 4),
             Position.new(5, 6)
           ]
  end

  test "knights are blocked by friendly pieces" do
    position = Position.new(3, 5)

    board = %{
      position => Piece.new(:knight, :white),
      Position.new(1, 4) => Piece.new(:knight, :white),
      Position.new(2, 3) => Piece.new(:knight, :white),
      Position.new(4, 3) => Piece.new(:knight, :white),
      Position.new(5, 6) => Piece.new(:knight, :white)
    }

    moves = Knight.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(1, 6),
             Position.new(2, 7),
             Position.new(4, 7),
             Position.new(5, 4)
           ]
  end

  test "knights can capture enemy pieces" do
    position = Position.new(3, 5)

    board = %{
      position => Piece.new(:knight, :white),
      Position.new(1, 4) => Piece.new(:knight, :black),
      Position.new(2, 3) => Piece.new(:knight, :black),
      Position.new(4, 3) => Piece.new(:knight, :black),
      Position.new(5, 6) => Piece.new(:knight, :black)
    }

    moves = Knight.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(1, 4),
             Position.new(1, 6),
             Position.new(2, 3),
             Position.new(2, 7),
             Position.new(4, 3),
             Position.new(4, 7),
             Position.new(5, 4),
             Position.new(5, 6)
           ]
  end
end
