defmodule Chess.Pieces.Queen do
  alias Chess.{Pieces.Rook, Pieces.Bishop}

  def legal_move?(board, color, from, to) do
    Enum.member?(moves(board, color, from), to)
  end

  def moves(board, color, position) do
    Rook.moves(board, color, position) ++ Bishop.moves(board, color, position)
  end
end
