defmodule ChessEngine.GameTest do
  use ExUnit.Case

  alias ChessEngine.{Board, Game, Piece, Position}

  test "you cannot move a nonexistent piece" do
    from = Position.new(0, 5)
    to = Position.new(0, 6)

    game =
      Game.new(
        players: ["white", "black"],
        state: :white_turn,
        board: %{}
      )

    assert Game.move(game, "white", from, to) ==
             {:error, "There is not a piece in that position."}
  end

  test "you cannot move another players piece" do
    from = Position.new(0, 5)
    to = Position.new(0, 6)

    board = %{
      from => Piece.new(:pawn, :black)
    }

    game =
      Game.new(
        players: ["white", "black"],
        state: :white_turn,
        board: board
      )

    assert Game.move(game, "white", from, to) ==
             {:error, "That piece does not belong to you."}
  end

  test "you can not move when it is not your turn" do
    from = Position.new(0, 5)
    to = Position.new(0, 6)

    board = %{
      from => Piece.new(:pawn, :black)
    }

    game =
      Game.new(
        players: ["white", "black"],
        state: :white_turn,
        board: board
      )

    assert Game.move(game, "black", from, to) ==
             {:error, "It is not your turn."}
  end

  test "when a valid move is made, the board is updated and the turn is passed to the other player" do
    active_color = :white
    from = Position.new(0, 5)
    to = Position.new(0, 6)

    board = %{
      from => Piece.new(:pawn, active_color)
    }

    game =
      Game.new(
        players: ["white", "black"],
        state: :white_turn,
        board: board
      )

    assert Game.move(game, "white", from, to) ==
             {:ok, %{game | state: :black_turn, board: %{to => Piece.new(:pawn, active_color)}}}
  end
end
