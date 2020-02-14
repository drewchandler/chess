defmodule ChessEngine.Pieces.Pawn do
  alias ChessEngine.{Board, Position}

  def legal_move?(board, color, from, to) do
    Enum.member?(moves(board, color, from), to)
  end

  def moves(board, color, position) do
    non_attacking_moves(board, color, position) ++ attacking_moves(board, color, position)
  end

  defp non_attacking_moves(board, color, position) do
    Enum.reject(
      forward_move(board, color, position) ++ double_step_move(board, color, position),
      &Board.occupied?(board, &1)
    )
  end

  defp attacking_moves(board, :white, %{x: x, y: y}) do
    Enum.filter(
      [%Position{x: x - 1, y: y + 1}, %Position{x: x + 1, y: y + 1}],
      &Board.occupied_by_color?(board, &1, :black)
    )
  end

  defp attacking_moves(board, :black, %{x: x, y: y}) do
    Enum.filter(
      [%Position{x: x - 1, y: y - 1}, %Position{x: x + 1, y: y - 1}],
      &Board.occupied_by_color?(board, &1, :white)
    )
  end

  defp forward_move(_, :white, %{x: x, y: y}), do: [%Position{x: x, y: y + 1}]
  defp forward_move(_, :black, %{x: x, y: y}), do: [%Position{x: x, y: y - 1}]

  defp double_step_move(board, :white, position = %{x: x, y: 1}) do
    if Board.occupied?(board, %{position | y: 2}), do: [], else: [%Position{x: x, y: 3}]
  end

  defp double_step_move(board, :black, position = %{x: x, y: 6}) do
    if Board.occupied?(board, %{position | y: 5}), do: [], else: [%Position{x: x, y: 4}]
  end

  defp double_step_move(_, _, _), do: []
end
