defmodule ChessWeb.GameChannel do
  alias Chess.{GameSession, Position}

  use ChessWeb, :channel

  def join("game:" <> name, _payload, socket) do
    if GameSession.exists?(name) do
      {:ok, %{game: GameSession.current_state(name)}, socket}
    else
      {:error, %{message: "Game does not exist"}}
    end
  end

  def handle_in("move", %{"from" => raw_from, "to" => raw_to}, socket) do
    with {:ok, from} <- convert_to_position(raw_from),
         {:ok, to} <- convert_to_position(raw_to),
         {:ok, game} <- GameSession.move(via(socket.topic), socket.assigns.username, from, to) do
      broadcast!(socket, "update", %{game: game})
      {:noreply, socket}
    else
      {:error, error} ->
        {:reply, {:error, %{message: error}}, socket}
    end
  end

  def handle_in("legal_moves", %{"position" => raw_position}, socket) do
    with {:ok, position} <- convert_to_position(raw_position),
         {:ok, moves} <- GameSession.legal_moves(via(socket.topic), position) do
      {:reply, {:ok, %{moves: moves}}, socket}
    else
      {:error, error} ->
        {:reply, {:error, %{message: error}}, socket}
    end
  end

  defp via("game:" <> name), do: name

  defp convert_to_position(num) when num < 0 or num > 63 do
    {:error, "Position is out of bounds"}
  end

  defp convert_to_position(num) do
    {:ok, Position.new(rem(num, 8), div(num, 8))}
  end
end
