defmodule Chess.Rules.MovesTest do
  use ExUnit.Case

  alias Chess.Rules.{Piece, Position, Moves}

  describe "bishops" do
    test "can move diagonally" do
      position = Position.new(3, 5)
      board = %{position => Piece.new(:bishop, :white)}

      moves = Moves.bishop_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(0, 2),
               Position.new(1, 3),
               Position.new(1, 7),
               Position.new(2, 4),
               Position.new(2, 6),
               Position.new(4, 4),
               Position.new(4, 6),
               Position.new(5, 3),
               Position.new(5, 7),
               Position.new(6, 2),
               Position.new(7, 1)
             ]
    end

    test "are blocked by friendly pieces" do
      position = Position.new(3, 5)

      board = %{
        position => Piece.new(:bishop, :white),
        Position.new(1, 3) => Piece.new(:bishop, :white),
        Position.new(1, 7) => Piece.new(:bishop, :white),
        Position.new(5, 3) => Piece.new(:bishop, :white),
        Position.new(5, 7) => Piece.new(:bishop, :white)
      }

      moves = Moves.bishop_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(2, 4),
               Position.new(2, 6),
               Position.new(4, 4),
               Position.new(4, 6)
             ]
    end

    test "are blocked by enemy pieces but they can capture" do
      position = Position.new(3, 5)

      board = %{
        position => Piece.new(:bishop, :white),
        Position.new(1, 3) => Piece.new(:bishop, :black),
        Position.new(1, 7) => Piece.new(:bishop, :black),
        Position.new(5, 3) => Piece.new(:bishop, :black),
        Position.new(5, 7) => Piece.new(:bishop, :black)
      }

      moves = Moves.bishop_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(1, 3),
               Position.new(1, 7),
               Position.new(2, 4),
               Position.new(2, 6),
               Position.new(4, 4),
               Position.new(4, 6),
               Position.new(5, 3),
               Position.new(5, 7)
             ]
    end
  end

  describe "kings" do
    test "can move 1 space in any direction" do
      position = Position.new(3, 5)
      board = %{position => Piece.new(:king, :white)}

      moves = Moves.king_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(2, 4),
               Position.new(2, 5),
               Position.new(2, 6),
               Position.new(3, 4),
               Position.new(3, 6),
               Position.new(4, 4),
               Position.new(4, 5),
               Position.new(4, 6)
             ]
    end

    test "are blocked by friendly pieces" do
      position = Position.new(3, 5)

      board = %{
        position => Piece.new(:king, :white),
        Position.new(2, 4) => Piece.new(:king, :white),
        Position.new(3, 4) => Piece.new(:king, :white),
        Position.new(4, 6) => Piece.new(:king, :white)
      }

      moves = Moves.king_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(2, 5),
               Position.new(2, 6),
               Position.new(3, 6),
               Position.new(4, 4),
               Position.new(4, 5)
             ]
    end

    test "can capture enemy pieces" do
      position = Position.new(3, 5)

      board = %{
        position => Piece.new(:king, :white),
        Position.new(2, 4) => Piece.new(:king, :black),
        Position.new(3, 4) => Piece.new(:king, :black),
        Position.new(4, 6) => Piece.new(:king, :black)
      }

      moves = Moves.king_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(2, 4),
               Position.new(2, 5),
               Position.new(2, 6),
               Position.new(3, 4),
               Position.new(3, 6),
               Position.new(4, 4),
               Position.new(4, 5),
               Position.new(4, 6)
             ]
    end
  end

  describe "knights" do
    test "can move in an L shape" do
      position = Position.new(3, 5)
      board = %{position => Piece.new(:knight, :white)}

      moves = Moves.knight_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(1, 4),
               Position.new(1, 6),
               Position.new(2, 3),
               Position.new(2, 7),
               Position.new(4, 3),
               Position.new(4, 7),
               Position.new(5, 4),
               Position.new(5, 6)
             ]
    end

    test "are blocked by friendly pieces" do
      position = Position.new(3, 5)

      board = %{
        position => Piece.new(:knight, :white),
        Position.new(1, 4) => Piece.new(:knight, :white),
        Position.new(2, 3) => Piece.new(:knight, :white),
        Position.new(4, 3) => Piece.new(:knight, :white),
        Position.new(5, 6) => Piece.new(:knight, :white)
      }

      moves = Moves.knight_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(1, 6),
               Position.new(2, 7),
               Position.new(4, 7),
               Position.new(5, 4)
             ]
    end

    test "can capture enemy pieces" do
      position = Position.new(3, 5)

      board = %{
        position => Piece.new(:knight, :white),
        Position.new(1, 4) => Piece.new(:knight, :black),
        Position.new(2, 3) => Piece.new(:knight, :black),
        Position.new(4, 3) => Piece.new(:knight, :black),
        Position.new(5, 6) => Piece.new(:knight, :black)
      }

      moves = Moves.knight_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(1, 4),
               Position.new(1, 6),
               Position.new(2, 3),
               Position.new(2, 7),
               Position.new(4, 3),
               Position.new(4, 7),
               Position.new(5, 4),
               Position.new(5, 6)
             ]
    end
  end

  describe "pawns" do
    test "when white can move up one space" do
      position = Position.new(0, 5)

      board = %{position => Piece.new(:pawn, :white)}

      assert Moves.pawn_moves(board, :white, position) == [Position.new(0, 6)]
    end

    test "when white can move up two spaces on the second row" do
      position = Position.new(0, 1)

      board = %{position => Piece.new(:pawn, :white)}

      assert Moves.pawn_moves(board, :white, position) == [Position.new(0, 2), Position.new(0, 3)]
    end

    test "when black can move down one space" do
      position = Position.new(0, 5)

      board = %{position => Piece.new(:pawn, :black)}

      assert Moves.pawn_moves(board, :black, position) == [Position.new(0, 4)]
    end

    test "when black can move down two spaces on the seventh row" do
      position = Position.new(0, 6)

      board = %{position => Piece.new(:pawn, :black)}

      assert Moves.pawn_moves(board, :black, position) == [Position.new(0, 5), Position.new(0, 4)]
    end

    test "pawns cannot move forward into an occupied space" do
      position = Position.new(0, 2)

      board = %{
        position => Piece.new(:pawn, :white),
        Position.new(0, 3) => Piece.new(:pawn, :white)
      }

      assert Moves.pawn_moves(board, :white, position) == []
    end

    test "cannot move two spaces over an occupied space" do
      position = Position.new(0, 1)

      board = %{
        position => Piece.new(:pawn, :white),
        Position.new(0, 2) => Piece.new(:pawn, :white)
      }

      assert Moves.pawn_moves(board, :white, position) == []
    end

    test "cannot move two spaces into an occupied space" do
      position = Position.new(0, 1)

      board = %{
        position => Piece.new(:pawn, :white),
        Position.new(0, 3) => Piece.new(:pawn, :white)
      }

      assert Moves.pawn_moves(board, :white, position) == [Position.new(0, 2)]
    end

    test "can capture diagonally" do
      position = Position.new(0, 5)
      opponent_position = Position.new(1, 6)

      board = %{
        position => Piece.new(:pawn, :white),
        opponent_position => Piece.new(:pawn, :black)
      }

      assert Moves.pawn_moves(board, :white, position) == [Position.new(0, 6), opponent_position]
    end

    test "cannot capture pieces of the same color" do
      position = Position.new(0, 5)

      board = %{
        position => Piece.new(:pawn, :white),
        Position.new(1, 6) => Piece.new(:pawn, :white)
      }

      assert Moves.pawn_moves(board, :white, position) == [Position.new(0, 6)]
    end
  end

  describe "queens" do
    test "can move diagonally, horizontally and vertically" do
      position = Position.new(3, 5)
      board = %{position => Piece.new(:queen, :white)}

      moves = Moves.queen_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(0, 2),
               Position.new(0, 5),
               Position.new(1, 3),
               Position.new(1, 5),
               Position.new(1, 7),
               Position.new(2, 4),
               Position.new(2, 5),
               Position.new(2, 6),
               Position.new(3, 0),
               Position.new(3, 1),
               Position.new(3, 2),
               Position.new(3, 3),
               Position.new(3, 4),
               Position.new(3, 6),
               Position.new(3, 7),
               Position.new(4, 4),
               Position.new(4, 5),
               Position.new(4, 6),
               Position.new(5, 3),
               Position.new(5, 5),
               Position.new(5, 7),
               Position.new(6, 2),
               Position.new(6, 5),
               Position.new(7, 1),
               Position.new(7, 5)
             ]
    end

    test "are blocked by friendly pieces" do
      position = Position.new(3, 5)

      board = %{
        position => Piece.new(:queen, :white),
        Position.new(1, 3) => Piece.new(:queen, :white),
        Position.new(1, 5) => Piece.new(:queen, :white),
        Position.new(1, 7) => Piece.new(:queen, :white),
        Position.new(3, 1) => Piece.new(:queen, :white),
        Position.new(3, 6) => Piece.new(:queen, :white),
        Position.new(5, 3) => Piece.new(:queen, :white),
        Position.new(5, 5) => Piece.new(:queen, :white),
        Position.new(5, 7) => Piece.new(:queen, :white)
      }

      moves = Moves.queen_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(2, 4),
               Position.new(2, 5),
               Position.new(2, 6),
               Position.new(3, 2),
               Position.new(3, 3),
               Position.new(3, 4),
               Position.new(4, 4),
               Position.new(4, 5),
               Position.new(4, 6)
             ]
    end

    test "are blocked by enemy pieces but they can capture" do
      position = Position.new(3, 5)

      board = %{
        position => Piece.new(:queen, :white),
        Position.new(1, 3) => Piece.new(:queen, :black),
        Position.new(1, 5) => Piece.new(:queen, :black),
        Position.new(1, 7) => Piece.new(:queen, :black),
        Position.new(3, 1) => Piece.new(:queen, :black),
        Position.new(3, 6) => Piece.new(:queen, :black),
        Position.new(5, 3) => Piece.new(:queen, :black),
        Position.new(5, 5) => Piece.new(:queen, :black),
        Position.new(5, 7) => Piece.new(:queen, :black)
      }

      moves = Moves.queen_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(1, 3),
               Position.new(1, 5),
               Position.new(1, 7),
               Position.new(2, 4),
               Position.new(2, 5),
               Position.new(2, 6),
               Position.new(3, 1),
               Position.new(3, 2),
               Position.new(3, 3),
               Position.new(3, 4),
               Position.new(3, 6),
               Position.new(4, 4),
               Position.new(4, 5),
               Position.new(4, 6),
               Position.new(5, 3),
               Position.new(5, 5),
               Position.new(5, 7)
             ]
    end
  end

  describe "rooks" do
    test "can move horizontally and vertically" do
      position = Position.new(3, 5)
      board = %{position => Piece.new(:rook, :white)}

      moves = Moves.rook_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(0, 5),
               Position.new(1, 5),
               Position.new(2, 5),
               Position.new(3, 0),
               Position.new(3, 1),
               Position.new(3, 2),
               Position.new(3, 3),
               Position.new(3, 4),
               Position.new(3, 6),
               Position.new(3, 7),
               Position.new(4, 5),
               Position.new(5, 5),
               Position.new(6, 5),
               Position.new(7, 5)
             ]
    end

    test "are blocked by friendly pieces" do
      position = Position.new(3, 5)

      board = %{
        position => Piece.new(:rook, :white),
        Position.new(1, 5) => Piece.new(:rook, :white),
        Position.new(5, 5) => Piece.new(:rook, :white),
        Position.new(3, 1) => Piece.new(:rook, :white),
        Position.new(3, 6) => Piece.new(:rook, :white)
      }

      moves = Moves.rook_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(2, 5),
               Position.new(3, 2),
               Position.new(3, 3),
               Position.new(3, 4),
               Position.new(4, 5)
             ]
    end

    test "are blocked by enemy pieces but they can capture" do
      position = Position.new(3, 5)

      board = %{
        position => Piece.new(:rook, :white),
        Position.new(1, 5) => Piece.new(:rook, :black),
        Position.new(5, 5) => Piece.new(:rook, :black),
        Position.new(3, 1) => Piece.new(:rook, :black),
        Position.new(3, 6) => Piece.new(:rook, :black)
      }

      moves = Moves.rook_moves(board, :white, position)

      assert sort_moves(moves) == [
               Position.new(1, 5),
               Position.new(2, 5),
               Position.new(3, 1),
               Position.new(3, 2),
               Position.new(3, 3),
               Position.new(3, 4),
               Position.new(3, 6),
               Position.new(4, 5),
               Position.new(5, 5)
             ]
    end
  end

  def sort_moves(moves) do
    moves |> Enum.sort(fn a, b -> a.x < b.x || (a.x == b.x && a.y <= b.y) end)
  end
end
