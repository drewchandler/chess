defimpl Jason.Encoder, for: [Chess.Rules.Position] do
  def encode(position, _opts) do
    Jason.Encode.integer(position.y * 8 + position.x)
  end
end
