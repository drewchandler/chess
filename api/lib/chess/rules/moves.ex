defmodule Chess.Rules.Moves do
  alias Chess.Rules.{Board, Piece, Position}

  def bishop_moves(board, color, position) do
    moves_in_direction(board, color, position, {-1, -1}, []) ++
      moves_in_direction(board, color, position, {-1, 1}, []) ++
      moves_in_direction(board, color, position, {1, -1}, []) ++
      moves_in_direction(board, color, position, {1, 1}, [])
  end

  def king_moves(board, color, position) do
    moves_from_deltas(
      board,
      color,
      position,
      [
        {-1, 1},
        {0, 1},
        {1, 1},
        {-1, 0},
        {1, 0},
        {-1, -1},
        {0, -1},
        {1, -1}
      ]
    )
  end

  def knight_moves(board, color, position) do
    moves_from_deltas(
      board,
      color,
      position,
      [
        {-1, -2},
        {-1, 2},
        {-2, -1},
        {-2, 1},
        {1, -2},
        {1, 2},
        {2, -1},
        {2, 1}
      ]
    )
  end

  def pawn_moves(board, color, position) do
    non_attacking_pawn_moves(board, color, position) ++
      attacking_pawn_moves(board, color, position)
  end

  defp non_attacking_pawn_moves(board, color, position) do
    Enum.reject(
      forward_pawn_move(board, color, position) ++ double_step_pawn_move(board, color, position),
      &Board.occupied?(board, &1)
    )
  end

  def queen_moves(board, color, position) do
    rook_moves(board, color, position) ++ bishop_moves(board, color, position)
  end

  def rook_moves(board, color, position) do
    moves_in_direction(board, color, position, {-1, 0}, []) ++
      moves_in_direction(board, color, position, {1, 0}, []) ++
      moves_in_direction(board, color, position, {0, -1}, []) ++
      moves_in_direction(board, color, position, {0, 1}, [])
  end

  defp attacking_pawn_moves(board, :white, %{x: x, y: y}) do
    Enum.filter(
      [Position.new(x - 1, y + 1), Position.new(x + 1, y + 1)],
      &Board.occupied_by_color?(board, &1, :black)
    )
  end

  defp attacking_pawn_moves(board, :black, %{x: x, y: y}) do
    Enum.filter(
      [Position.new(x - 1, y - 1), Position.new(x + 1, y - 1)],
      &Board.occupied_by_color?(board, &1, :white)
    )
  end

  defp forward_pawn_move(_, :white, %{x: x, y: y}), do: [Position.new(x, y + 1)]
  defp forward_pawn_move(_, :black, %{x: x, y: y}), do: [Position.new(x, y - 1)]

  defp double_step_pawn_move(board, :white, position = %{x: x, y: 1}) do
    if Board.occupied?(board, %{position | y: 2}), do: [], else: [Position.new(x, 3)]
  end

  defp double_step_pawn_move(board, :black, position = %{x: x, y: 6}) do
    if Board.occupied?(board, %{position | y: 5}), do: [], else: [Position.new(x, 4)]
  end

  defp double_step_pawn_move(_, _, _), do: []

  defp moves_in_direction(board, color, position, step, moves) do
    new_position = Position.translate(position, step)

    if Position.in_bounds?(new_position) do
      case Board.piece_at(board, new_position) do
        %Piece{color: ^color} -> moves
        %Piece{} -> [new_position | moves]
        nil -> moves_in_direction(board, color, new_position, step, [new_position | moves])
      end
    else
      moves
    end
  end

  defp moves_from_deltas(board, color, position, deltas) do
    deltas
    |> Enum.map(&Position.translate(position, &1))
    |> Enum.filter(&Position.in_bounds?/1)
    |> Enum.reject(&Board.occupied_by_color?(board, &1, color))
  end
end
