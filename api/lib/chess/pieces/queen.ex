defmodule Chess.Pieces.Queen do
  alias Chess.{Pieces.Rook, Pieces.Bishop}

  def moves(board, color, position) do
    Rook.moves(board, color, position) ++ Bishop.moves(board, color, position)
  end
end
