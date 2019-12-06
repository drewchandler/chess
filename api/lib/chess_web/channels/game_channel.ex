defmodule ChessWeb.GameChannel do
  use ChessWeb, :channel

  @initial_game %{
    state: "in-progress",
    board: %{
      0 => %{type: 1, player: 0},
      1 => %{type: 2, player: 0},
      2 => %{type: 3, player: 0},
      3 => %{type: 5, player: 0},
      4 => %{type: 4, player: 0},
      5 => %{type: 3, player: 0},
      6 => %{type: 2, player: 0},
      7 => %{type: 1, player: 0},
      8 => %{type: 0, player: 0},
      9 => %{type: 0, player: 0},
      10 => %{type: 0, player: 0},
      11 => %{type: 0, player: 0},
      12 => %{type: 0, player: 0},
      13 => %{type: 0, player: 0},
      14 => %{type: 0, player: 0},
      15 => %{type: 0, player: 0},
      48 => %{type: 0, player: 1},
      49 => %{type: 0, player: 1},
      50 => %{type: 0, player: 1},
      51 => %{type: 0, player: 1},
      52 => %{type: 0, player: 1},
      53 => %{type: 0, player: 1},
      54 => %{type: 0, player: 1},
      55 => %{type: 0, player: 1},
      56 => %{type: 1, player: 1},
      57 => %{type: 2, player: 1},
      58 => %{type: 3, player: 1},
      59 => %{type: 5, player: 1},
      60 => %{type: 4, player: 1},
      61 => %{type: 3, player: 1},
      62 => %{type: 2, player: 1},
      63 => %{type: 1, player: 1}
    }
  }

  def join("game:" <> _player, _payload, socket) do
    {:ok, %{game: @initial_game}, socket}
  end
end
