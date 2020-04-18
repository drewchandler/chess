defmodule Chess.Pieces.Bishop do
  alias Chess.{Board, Piece, Position}

  def legal_move?(board, color, from, to) do
    Enum.member?(moves(board, color, from), to)
  end

  def moves(board, color, position) do
    moves_in_direction(board, color, position, {-1, -1}, []) ++
      moves_in_direction(board, color, position, {-1, 1}, []) ++
      moves_in_direction(board, color, position, {1, -1}, []) ++
      moves_in_direction(board, color, position, {1, 1}, [])
  end

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
end
