defimpl Jason.Encoder, for: [Chess.Game] do
  def encode(game, opts) do
    game
    |> Map.take([:players, :state, :clocks])
    |> Map.put(
      :board,
      for(
        {position, piece} <- game.board,
        into: %{},
        do: {position.y * 8 + position.x, piece}
      )
    )
    |> Jason.Encode.map(opts)
  end
end
