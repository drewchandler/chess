defimpl Jason.Encoder, for: [Chess.Position] do
  def encode(position, _opts) do
    (position.y * 8 + position.x)
    |> Jason.Encode.integer()
  end
end
