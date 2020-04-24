defmodule MoveHelpers do
  defmacro __using__(_options) do
    quote do
      import MoveHelpers, only: :functions
    end
  end

  def sort_moves(moves) do
    moves |> Enum.sort(fn a, b -> a.x < b.x || (a.x == b.x && a.y <= b.y) end)
  end
end
