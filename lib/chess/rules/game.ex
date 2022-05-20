defmodule Chess.Rules.Game do
  alias Chess.Rules.{Board, CheckDetection}

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
      opponent_mated = CheckDetection.mate?(new_board, enemy_color(color))

      {:ok, %{game | board: new_board, state: next_state(game, opponent_mated)}}
    end
  end

  def done?(%{state: :white_victory}), do: true
  def done?(%{state: :black_victory}), do: true
  def done?(_), do: false

  def legal_moves(game, position), do: Board.legal_moves(game.board, position)

  def color_for_player(%{players: [player, _]}, player), do: {:ok, :white}
  def color_for_player(%{players: [_, player]}, player), do: {:ok, :black}
  def color_for_player(_, player), do: {:error, "'#{player}' is not a player in this game."}

  def active_player(%{state: :white_turn, players: [player, _]}), do: player
  def active_player(%{state: :black_turn, players: [_, player]}), do: player
  def active_player(_), do: nil

  def winning_player(%{state: :white_victory, players: [player, _]}), do: player
  def winning_player(%{state: :black_victory, players: [_, player]}), do: player
  def winning_player(_), do: nil

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

  defp enemy_color(:black), do: :white
  defp enemy_color(:white), do: :black
end
