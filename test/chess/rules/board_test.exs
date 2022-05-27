defmodule Chess.Rules.BoardTest do
  alias Chess.Rules.{Board, Piece, Position}
  use ExUnit.Case

  describe "move/3" do
    test "you can move pieces into empty squares" do
      board = %{
        Position.new(0, 2) => Piece.new(:rook, :white),
        Position.new(0, 5) => Piece.new(:pawn, :black),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      {:ok, new_board} = Board.move(board, Position.new(0, 2), Position.new(0, 4))

      assert new_board == %{
               Position.new(0, 4) => Piece.new(:rook, :white),
               Position.new(0, 5) => Piece.new(:pawn, :black),
               Position.new(4, 0) => Piece.new(:king, :white),
               Position.new(4, 7) => Piece.new(:king, :black)
             }
    end

    test "you can move pieces into occupied squares" do
      board = %{
        Position.new(0, 2) => Piece.new(:rook, :white),
        Position.new(0, 5) => Piece.new(:pawn, :black),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      {:ok, new_board} = Board.move(board, Position.new(0, 2), Position.new(0, 5))

      assert new_board == %{
               Position.new(0, 5) => Piece.new(:rook, :white),
               Position.new(4, 0) => Piece.new(:king, :white),
               Position.new(4, 7) => Piece.new(:king, :black)
             }
    end

    test "can't move into check" do
      from = Position.new(4, 1)
      to = Position.new(0, 1)

      board = %{
        from => Piece.new(:rook, :white),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 2) => Piece.new(:rook, :black),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      assert Board.move(board, from, to) == {:error, "Attempted move is not legal."}
    end
  end

  describe "legal_moves/3" do
    test "gives legal moves for a position with a bishop" do
      position = Position.new(0, 0)

      board = %{
        position => Piece.new(:bishop, :white),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      assert Board.legal_moves(board, position) == [
               Position.new(7, 7),
               Position.new(6, 6),
               Position.new(5, 5),
               Position.new(4, 4),
               Position.new(3, 3),
               Position.new(2, 2),
               Position.new(1, 1)
             ]
    end

    test "gives legal moves for a position with a king" do
      position = Position.new(0, 0)

      board = %{
        position => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      assert Board.legal_moves(board, position) == [
               Position.new(0, 1),
               Position.new(1, 1),
               Position.new(1, 0)
             ]
    end

    test "gives legal moves for a position with a knight" do
      position = Position.new(0, 0)

      board = %{
        position => Piece.new(:knight, :white),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      assert Board.legal_moves(board, position) == [
               Position.new(1, 2),
               Position.new(2, 1)
             ]
    end

    test "gives legal moves for a position with a pawn" do
      position = Position.new(0, 0)

      board = %{
        position => Piece.new(:pawn, :white),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      assert Board.legal_moves(board, position) == [
               Position.new(0, 1)
             ]
    end

    test "gives legal moves for a position with a queen" do
      position = Position.new(0, 0)

      board = %{
        position => Piece.new(:queen, :white),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      assert Board.legal_moves(board, position) == [
               Position.new(3, 0),
               Position.new(2, 0),
               Position.new(1, 0),
               Position.new(0, 7),
               Position.new(0, 6),
               Position.new(0, 5),
               Position.new(0, 4),
               Position.new(0, 3),
               Position.new(0, 2),
               Position.new(0, 1),
               Position.new(7, 7),
               Position.new(6, 6),
               Position.new(5, 5),
               Position.new(4, 4),
               Position.new(3, 3),
               Position.new(2, 2),
               Position.new(1, 1)
             ]
    end

    test "gives legal moves for a position with a rook" do
      position = Position.new(0, 0)

      board = %{
        position => Piece.new(:rook, :white),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      assert Board.legal_moves(board, position) == [
               Position.new(3, 0),
               Position.new(2, 0),
               Position.new(1, 0),
               Position.new(0, 7),
               Position.new(0, 6),
               Position.new(0, 5),
               Position.new(0, 4),
               Position.new(0, 3),
               Position.new(0, 2),
               Position.new(0, 1)
             ]
    end

    test "gives legal moves for an empty position" do
      position = Position.new(0, 0)

      board = %{
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      assert Board.legal_moves(board, position) == []
    end
  end

  describe "piece_at/2" do
    test "you can ask for the piece at a given position" do
      board = %{
        Position.new(0, 2) => Piece.new(:rook, :white),
        Position.new(0, 5) => Piece.new(:pawn, :black),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      result = Board.piece_at(board, Position.new(0, 5))

      assert result == Piece.new(:pawn, :black)
    end
  end

  describe "occupied?/2" do
    test "you can ask if a position is occupied" do
      board = %{
        Position.new(0, 2) => Piece.new(:rook, :white),
        Position.new(0, 5) => Piece.new(:pawn, :black),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      assert Board.occupied?(board, Position.new(0, 2))
      refute Board.occupied?(board, Position.new(5, 2))
    end
  end

  describe "occupied_by_color?/3" do
    test "you can ask if a position is occupied by a color" do
      board = %{
        Position.new(0, 2) => Piece.new(:rook, :white),
        Position.new(0, 5) => Piece.new(:pawn, :black),
        Position.new(4, 0) => Piece.new(:king, :white),
        Position.new(4, 7) => Piece.new(:king, :black)
      }

      assert Board.occupied_by_color?(board, Position.new(0, 2), :white)
      refute Board.occupied_by_color?(board, Position.new(0, 2), :black)
      refute Board.occupied_by_color?(board, Position.new(5, 2), :white)
    end
  end
end
