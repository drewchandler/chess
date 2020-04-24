defmodule Chess.Pieces.KingTest do
  use ExUnit.Case
  use MoveHelpers

  alias Chess.{Piece, Pieces.King, Position}

  test "kings can move 1 space in any direction" do
    position = Position.new(3, 5)
    board = %{position => Piece.new(:king, :white)}

    moves = King.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(2, 4),
             Position.new(2, 5),
             Position.new(2, 6),
             Position.new(3, 4),
             Position.new(3, 6),
             Position.new(4, 4),
             Position.new(4, 5),
             Position.new(4, 6)
           ]
  end

  test "kings are blocked by friendly pieces" do
    position = Position.new(3, 5)

    board = %{
      position => Piece.new(:king, :white),
      Position.new(2, 4) => Piece.new(:king, :white),
      Position.new(3, 4) => Piece.new(:king, :white),
      Position.new(4, 6) => Piece.new(:king, :white)
    }

    moves = King.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(2, 5),
             Position.new(2, 6),
             Position.new(3, 6),
             Position.new(4, 4),
             Position.new(4, 5)
           ]
  end

  test "kings can capture enemy pieces" do
    position = Position.new(3, 5)

    board = %{
      position => Piece.new(:king, :white),
      Position.new(2, 4) => Piece.new(:king, :black),
      Position.new(3, 4) => Piece.new(:king, :black),
      Position.new(4, 6) => Piece.new(:king, :black)
    }

    moves = King.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(2, 4),
             Position.new(2, 5),
             Position.new(2, 6),
             Position.new(3, 4),
             Position.new(3, 6),
             Position.new(4, 4),
             Position.new(4, 5),
             Position.new(4, 6)
           ]
  end
end
