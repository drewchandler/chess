defmodule Chess.Board do
  alias Chess.{
    Piece,
    Position,
    Pieces.Bishop,
    Pieces.King,
    Pieces.Knight,
    Pieces.Pawn,
    Pieces.Queen,
    Pieces.Rook
  }

  @initial_board %{
    Position.new(0, 0) => Piece.new(:rook, :white),
    Position.new(1, 0) => Piece.new(:knight, :white),
    Position.new(2, 0) => Piece.new(:bishop, :white),
    Position.new(3, 0) => Piece.new(:queen, :white),
    Position.new(4, 0) => Piece.new(:king, :white),
    Position.new(5, 0) => Piece.new(:bishop, :white),
    Position.new(6, 0) => Piece.new(:knight, :white),
    Position.new(7, 0) => Piece.new(:rook, :white),
    Position.new(0, 1) => Piece.new(:pawn, :white),
    Position.new(1, 1) => Piece.new(:pawn, :white),
    Position.new(2, 1) => Piece.new(:pawn, :white),
    Position.new(3, 1) => Piece.new(:pawn, :white),
    Position.new(4, 1) => Piece.new(:pawn, :white),
    Position.new(5, 1) => Piece.new(:pawn, :white),
    Position.new(6, 1) => Piece.new(:pawn, :white),
    Position.new(7, 1) => Piece.new(:pawn, :white),
    Position.new(0, 6) => Piece.new(:pawn, :black),
    Position.new(1, 6) => Piece.new(:pawn, :black),
    Position.new(2, 6) => Piece.new(:pawn, :black),
    Position.new(3, 6) => Piece.new(:pawn, :black),
    Position.new(4, 6) => Piece.new(:pawn, :black),
    Position.new(5, 6) => Piece.new(:pawn, :black),
    Position.new(6, 6) => Piece.new(:pawn, :black),
    Position.new(7, 6) => Piece.new(:pawn, :black),
    Position.new(0, 7) => Piece.new(:rook, :black),
    Position.new(1, 7) => Piece.new(:knight, :black),
    Position.new(2, 7) => Piece.new(:bishop, :black),
    Position.new(3, 7) => Piece.new(:queen, :black),
    Position.new(4, 7) => Piece.new(:king, :black),
    Position.new(5, 7) => Piece.new(:bishop, :black),
    Position.new(6, 7) => Piece.new(:knight, :black),
    Position.new(7, 7) => Piece.new(:rook, :black)
  }

  def initial_board, do: @initial_board

  def move(board, from, to) do
    {piece, board} = Map.pop(board, from)
    Map.put(board, to, piece)
  end

  def piece_at(board, position), do: board[position]

  def occupied?(board, position), do: !is_nil(piece_at(board, position))

  def occupied_by_color?(board, position, color) do
    case piece_at(board, position) do
      %{color: ^color} -> true
      _ -> false
    end
  end

  def legal_moves(board, position) do
    piece = piece_at(board, position)

    board
    |> moves_for_piece(piece, position)
    |> Enum.reject(&moves_self_into_check?(board, piece.color, position, &1))
  end

  defp moves_for_piece(board, piece, position) do
    case piece do
      %Piece{type: :bishop, color: color} -> Bishop.moves(board, color, position)
      %Piece{type: :king, color: color} -> King.moves(board, color, position)
      %Piece{type: :knight, color: color} -> Knight.moves(board, color, position)
      %Piece{type: :pawn, color: color} -> Pawn.moves(board, color, position)
      %Piece{type: :queen, color: color} -> Queen.moves(board, color, position)
      %Piece{type: :rook, color: color} -> Rook.moves(board, color, position)
      _ -> []
    end
  end

  defp moves_self_into_check?(board, color, from, to) do
    board
    |> move(from, to)
    |> check?(color)
  end

  defp check?(board, color) do
    king_position =
      board
      |> Enum.find(fn {_, piece} -> piece == Piece.new(:king, color) end)
      |> elem(0)

    board
    |> pieces_for_color(enemy_color(color))
    |> Stream.flat_map(fn {position, piece} -> moves_for_piece(board, piece, position) end)
    |> Enum.member?(king_position)
  end

  defp pieces_for_color(board, color) do
    Enum.filter(board, fn {_, piece} -> piece.color == color end)
  end

  defp enemy_color(:black), do: :white
  defp enemy_color(:white), do: :black
end
