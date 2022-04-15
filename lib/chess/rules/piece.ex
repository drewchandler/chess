defmodule Chess.Rules.Piece do
  @enforce_keys [:type, :color]
  @derive Jason.Encoder
  defstruct [:type, :color]

  def new(type, color), do: %__MODULE__{type: type, color: color}
end
