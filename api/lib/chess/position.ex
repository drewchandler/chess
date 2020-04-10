defmodule Chess.Position do
  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  def new(x, y), do: %__MODULE__{x: x, y: y}

  def in_bounds?(%{x: x, y: y}) do
    x >= 0 && x <= 7 && y >= 0 && y <= 7
  end

  def translate(%{x: x, y: y}, {delta_x, delta_y}) do
    new(x + delta_x, y + delta_y)
  end
end
