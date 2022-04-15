defimpl Jason.Encoder, for: [Chess.Rules.Game] do
  def encode(game, opts) do
    game
    |> Map.take([:players, :state])
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
