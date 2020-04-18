defmodule Chess.Pieces.QueenTest do
  use ExUnit.Case

  alias Chess.{Piece, Pieces.Queen, Position}

  test "queens can move diagonally, horizontally and vertically" do
    position = Position.new(3, 5)
    board = %{position => Piece.new(:queen, :white)}

    moves = Queen.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(0, 2),
             Position.new(0, 5),
             Position.new(1, 3),
             Position.new(1, 5),
             Position.new(1, 7),
             Position.new(2, 4),
             Position.new(2, 5),
             Position.new(2, 6),
             Position.new(3, 0),
             Position.new(3, 1),
             Position.new(3, 2),
             Position.new(3, 3),
             Position.new(3, 4),
             Position.new(3, 6),
             Position.new(3, 7),
             Position.new(4, 4),
             Position.new(4, 5),
             Position.new(4, 6),
             Position.new(5, 3),
             Position.new(5, 5),
             Position.new(5, 7),
             Position.new(6, 2),
             Position.new(6, 5),
             Position.new(7, 1),
             Position.new(7, 5)
           ]
  end

  test "queens are blocked by friendly pieces" do
    position = Position.new(3, 5)

    board = %{
      position => Piece.new(:queen, :white),
      Position.new(1, 3) => Piece.new(:queen, :white),
      Position.new(1, 5) => Piece.new(:queen, :white),
      Position.new(1, 7) => Piece.new(:queen, :white),
      Position.new(3, 1) => Piece.new(:queen, :white),
      Position.new(3, 6) => Piece.new(:queen, :white),
      Position.new(5, 3) => Piece.new(:queen, :white),
      Position.new(5, 5) => Piece.new(:queen, :white),
      Position.new(5, 7) => Piece.new(:queen, :white)
    }

    moves = Queen.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(2, 4),
             Position.new(2, 5),
             Position.new(2, 6),
             Position.new(3, 2),
             Position.new(3, 3),
             Position.new(3, 4),
             Position.new(4, 4),
             Position.new(4, 5),
             Position.new(4, 6)
           ]
  end

  test "queens are blocked by enemy pieces but they can capture" do
    position = Position.new(3, 5)

    board = %{
      position => Piece.new(:queen, :white),
      Position.new(1, 3) => Piece.new(:queen, :black),
      Position.new(1, 5) => Piece.new(:queen, :black),
      Position.new(1, 7) => Piece.new(:queen, :black),
      Position.new(3, 1) => Piece.new(:queen, :black),
      Position.new(3, 6) => Piece.new(:queen, :black),
      Position.new(5, 3) => Piece.new(:queen, :black),
      Position.new(5, 5) => Piece.new(:queen, :black),
      Position.new(5, 7) => Piece.new(:queen, :black)
    }

    moves = Queen.moves(board, :white, position)

    assert sort_moves(moves) == [
             Position.new(1, 3),
             Position.new(1, 5),
             Position.new(1, 7),
             Position.new(2, 4),
             Position.new(2, 5),
             Position.new(2, 6),
             Position.new(3, 1),
             Position.new(3, 2),
             Position.new(3, 3),
             Position.new(3, 4),
             Position.new(3, 6),
             Position.new(4, 4),
             Position.new(4, 5),
             Position.new(4, 6),
             Position.new(5, 3),
             Position.new(5, 5),
             Position.new(5, 7)
           ]
  end

  defp sort_moves(moves) do
    moves |> Enum.sort(fn a, b -> a.x < b.x || (a.x == b.x && a.y <= b.y) end)
  end
end
