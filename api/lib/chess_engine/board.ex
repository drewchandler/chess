defmodule ChessEngine.Board do
  alias ChessEngine.{Piece, Position}

  @initial_board %{
    Position.new(0, 0) => Piece.new(:rook, :white),
    Position.new(1, 0) => Piece.new(:knight, :white),
    Position.new(2, 0) => Piece.new(:bishop, :white),
    Position.new(3, 0) => Piece.new(:queen, :white),
    Position.new(4, 0) => Piece.new(:king, :white),
    Position.new(5, 0) => Piece.new(:bishop, :white),
    Position.new(6, 0) => Piece.new(:knight, :white),
    Position.new(7, 0) => Piece.new(:rook, :white),
    Position.new(0, 1) => Piece.new(:pawn, :white),
    Position.new(1, 1) => Piece.new(:pawn, :white),
    Position.new(2, 1) => Piece.new(:pawn, :white),
    Position.new(3, 1) => Piece.new(:pawn, :white),
    Position.new(4, 1) => Piece.new(:pawn, :white),
    Position.new(5, 1) => Piece.new(:pawn, :white),
    Position.new(6, 1) => Piece.new(:pawn, :white),
    Position.new(7, 1) => Piece.new(:pawn, :white),
    Position.new(0, 6) => Piece.new(:pawn, :black),
    Position.new(1, 6) => Piece.new(:pawn, :black),
    Position.new(2, 6) => Piece.new(:pawn, :black),
    Position.new(3, 6) => Piece.new(:pawn, :black),
    Position.new(4, 6) => Piece.new(:pawn, :black),
    Position.new(5, 6) => Piece.new(:pawn, :black),
    Position.new(6, 6) => Piece.new(:pawn, :black),
    Position.new(7, 6) => Piece.new(:pawn, :black),
    Position.new(0, 7) => Piece.new(:rook, :black),
    Position.new(1, 7) => Piece.new(:knight, :black),
    Position.new(2, 7) => Piece.new(:bishop, :black),
    Position.new(3, 7) => Piece.new(:queen, :black),
    Position.new(4, 7) => Piece.new(:king, :black),
    Position.new(5, 7) => Piece.new(:bishop, :black),
    Position.new(6, 7) => Piece.new(:knight, :black),
    Position.new(7, 7) => Piece.new(:rook, :black)
  }

  def initial_board, do: @initial_board

  def move(board, from, to) do
    {piece, board} = Map.pop(board, from)
    Map.put(board, to, piece)
  end

  def piece_at(board, position), do: board[position]

  def occupied?(board, position), do: !is_nil(piece_at(board, position))

  def occupied_by_color?(board, position, color) do
    case piece_at(board, position) do
      %{color: ^color} -> true
      _ -> false
    end
  end
end
