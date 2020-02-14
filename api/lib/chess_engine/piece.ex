defmodule ChessEngine.Piece do
  @enforce_keys [:type, :color]
  defstruct [:type, :color]
end
