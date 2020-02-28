defmodule ChessWeb.GameChannel do
  use ChessWeb, :channel

  def join("game:" <> _game_id, _payload, socket) do
    {:ok, %{game: Chess.Game.new(players: [socket.assigns.username, "opponent"])}, socket}
  end
end
