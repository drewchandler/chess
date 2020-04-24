defmodule Chess.Pieces.King do
  alias Chess.{Board, Position}

  def moves(board, color, position) do
    move_deltas = [
      {-1, 1},
      {0, 1},
      {1, 1},
      {-1, 0},
      {1, 0},
      {-1, -1},
      {0, -1},
      {1, -1}
    ]

    move_deltas
    |> Enum.map(&Position.translate(position, &1))
    |> Enum.filter(&Position.in_bounds?/1)
    |> Enum.reject(&Board.occupied_by_color?(board, &1, color))
  end
end
