defmodule GameBuilders do
  defmacro __using__(_options) do
    quote do
      alias Chess.{Board, Game, Piece, Position}
      import GameBuilders, only: :functions
    end
  end

  alias Chess.Game

  def build_game(overrides \\ []) do
    overrides
    |> game_fields()
    |> Game.new()
  end

  def game_fields(overrides) do
    Keyword.merge(
      [players: ["white", "black"], clocks: [600_000, 600_000]],
      overrides
    )
  end
end
