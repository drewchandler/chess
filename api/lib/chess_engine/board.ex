defmodule ChessEngine.Board do
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
