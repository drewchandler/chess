defmodule Chess.Position do
  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  def new(x, y), do: %__MODULE__{x: x, y: y}
end
