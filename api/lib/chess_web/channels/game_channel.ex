defmodule ChessWeb.GameChannel do
  alias Chess.{GameSession, Position}

  use ChessWeb, :channel

  def join("game:" <> name, _payload, socket) do
    {:ok, %{game: GameSession.current_state(name)}, socket}
  end

  def handle_in("move", %{"from" => raw_from, "to" => raw_to}, socket) do
    with {:ok, from} <- translate_position(raw_from),
         {:ok, to} <- translate_position(raw_to),
         {:ok, game} <- GameSession.move(via(socket.topic), socket.assigns.username, from, to) do
      broadcast!(socket, "update", %{game: game})
      {:noreply, socket}
    else
      {:error, error} ->
        {:reply, {:error, %{message: error}}, socket}
    end
  end

  defp via("game:" <> name), do: name

  defp translate_position(num) when num < 0 or num > 63 do
    {:error, "Position is out of bounds"}
  end

  defp translate_position(num) do
    {:ok, Position.new(rem(num, 8), div(num, 8))}
  end
end
