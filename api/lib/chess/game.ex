defmodule Chess.Game do
  alias Chess.{Board, CheckDetection}

  @enforce_keys [:board, :players, :state]
  defstruct [:board, :players, :state]

  def new(fields) do
    struct!(
      __MODULE__,
      Keyword.merge([board: Board.initial_board(), state: :white_turn], fields)
    )
  end

  def move(game, player, from, to) do
    with {:ok, color} <- color_for_player(game, player),
         :ok <- validate_color_is_active(game, color),
         {:ok, piece} <- piece_at(game, from),
         :ok <- validate_piece_belongs_to_color(piece, color),
         {:ok, new_board} <- Board.move(game.board, from, to) do
      opponent_mated =
        new_board
        |> CheckDetection.mate?(enemy_color(color))

      {:ok, %{game | board: new_board, state: next_state(game, opponent_mated)}}
    end
  end

  def legal_moves(game, position), do: Board.legal_moves(game.board, position)

  defp color_for_player(%{players: [player, _]}, player), do: {:ok, :white}
  defp color_for_player(%{players: [_, player]}, player), do: {:ok, :black}
  defp color_for_player(_, _), do: {:error, "You are not a player in this game."}

  defp validate_color_is_active(%{state: :white_turn}, :white), do: :ok
  defp validate_color_is_active(%{state: :black_turn}, :black), do: :ok
  defp validate_color_is_active(_, _), do: {:error, "It is not your turn."}

  defp piece_at(%{board: board}, position) do
    case Board.piece_at(board, position) do
      nil -> {:error, "There is not a piece in that position."}
      piece -> {:ok, piece}
    end
  end

  defp validate_piece_belongs_to_color(%{color: :white}, :white), do: :ok
  defp validate_piece_belongs_to_color(%{color: :black}, :black), do: :ok
  defp validate_piece_belongs_to_color(_, _), do: {:error, "That piece does not belong to you."}

  defp next_state(%{state: :white_turn}, true), do: :white_victory
  defp next_state(%{state: :black_turn}, true), do: :black_victory
  defp next_state(%{state: :white_turn}, false), do: :black_turn
  defp next_state(%{state: :black_turn}, false), do: :white_turn
  defp next_state(%{state: state}, _), do: state

  defp enemy_color(:black), do: :white
  defp enemy_color(:white), do: :black
end
