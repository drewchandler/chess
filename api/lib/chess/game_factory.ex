defmodule Chess.GameFactory do
  use GenStage

  def start_link(producer, options \\ []) do
    GenStage.start_link(__MODULE__, producer, options)
  end

  def init(producer) do
    {:producer_consumer, :ok, subscribe_to: [producer]}
  end

  def handle_events(events, _from, state) do
    events
    |> Enum.map(&make_match/1)
    |> (&{:noreply, &1, state}).()
  end

  defp make_match(players) do
    name = UUID.uuid4(:hex)
    Chess.GameSession.start_game(name, players)

    %{name: name, players: players}
  end
end
