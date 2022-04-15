defmodule Chess.Rules.CheckDetection do
  alias Chess.Rules.{Board, Piece}

  def check?(board, color) do
    king_position = find_king(board, color)

    board
    |> pieces_for_color(enemy_color(color))
    |> Stream.flat_map(fn {position, _} -> Board.all_moves(board, position) end)
    |> Enum.member?(king_position)
  end

  def mate?(board, color) do
    board
    |> pieces_for_color(color)
    |> Stream.flat_map(fn {position, _} -> Board.legal_moves(board, position) end)
    |> Enum.any?()
    |> Kernel.not()
  end

  defp find_king(board, color) do
    board
    |> Enum.find(fn {_, piece} -> piece == Piece.new(:king, color) end)
    |> elem(0)
  end

  defp pieces_for_color(board, color) do
    Enum.filter(board, fn {_, piece} -> piece.color == color end)
  end

  defp enemy_color(:black), do: :white
  defp enemy_color(:white), do: :black
end
