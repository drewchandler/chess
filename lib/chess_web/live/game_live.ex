defmodule ChessWeb.GameLive do
  use ChessWeb, :live_view

  alias Chess.{GameSession, Rules.Board, Rules.Game, Rules.Position}
  alias ChessWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    ~H"""
    <%= if @error do %>
      <.error_modal error={@error} />
    <% else %>
      <.game game={@game} current_user={@current_user} highlighted_moves={@highlighted_moves} />
    <% end %>
    """
  end

  @impl true
  def mount(%{"id" => name}, _session, socket) do
    if GameSession.exists?(name) do
      ChessWeb.Endpoint.subscribe("game:" <> name)

      {:ok,
       assign(socket,
         name: name,
         game: GameSession.current_state(name),
         error: nil,
         highlighted_moves: []
       )}
    else
      {:ok, assign(socket, error: "Game does not exist")}
    end
  end

  @impl true
  def handle_event("get-moves", %{"x" => x, "y" => y}, socket) do
    moves = Game.legal_moves(socket.assigns[:game], Position.new(x, y))

    {:noreply, assign(socket, highlighted_moves: moves)}
  end

  @impl true
  def handle_event("clear-moves", _, socket) do
    {:noreply, assign(socket, highlighted_moves: [])}
  end

  @impl true
  def handle_event("move", %{"from" => from, "to" => to}, socket) do
    case Chess.GameSession.move(
           socket.assigns[:name],
           socket.assigns[:current_user],
           Position.new(from["x"], from["y"]),
           Position.new(to["x"], to["y"])
         ) do
      {:ok, game} ->
        ChessWeb.Endpoint.broadcast!("game:" <> socket.assigns[:name], "update", game)
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info(%{event: "update", payload: game}, socket) do
    {:noreply, assign(socket, game: game, highlighted_moves: [])}
  end

  defp error_modal(assigns) do
    ~H"""
    <.modal>
      <.stack gap="6">
        <.typography variant="error"><%= @error %></.typography>
        <.button patch={Routes.lobby_path(ChessWeb.Endpoint, :index)}>Back</.button>
      </.stack>
    </.modal>
    """
  end

  defp game(assigns) do
    {:ok, player_color} = Game.color_for_player(assigns[:game], assigns[:current_user])

    assigns = assign(assigns, player_color: player_color)

    ~H"""
    <.center>
      <.split fraction="3/4">
        <.stack>
          <%= if Game.done?(@game) do %>
            <.typography variant="title" text_align="center" gutter="4">
              <%= Game.winning_player(@game) %> won!
            </.typography>
          <% end %>

          <.board game={@game} player_color={@player_color} highlighted_moves={@highlighted_moves} />
        </.stack>

        <.players game={@game} player_color={@player_color} />
      </.split>
    </.center>
    """
  end

  defp board(assigns) do
    ys = if assigns[:player_color] == :white, do: 7..0, else: 0..7
    xs = if assigns[:player_color] == :white, do: 0..7, else: 7..0
    squares = for y <- ys, x <- xs, do: [x, y]

    assigns = assign(assigns, squares: squares)

    ~H"""
    <.center>
      <div id="board" phx-hook="Board" class="flex flex-wrap h-[75vmin] w-[75vmin]">
        <%= for [x, y] <- @squares do %>
          <.square
            game={@game}
            player_color={@player_color}
            x={x}
            y={y}
            highlighted={square_is_highlighted?(x, y, @highlighted_moves)}
          />
        <% end %>
      </div>
    </.center>
    """
  end

  def square_is_highlighted?(x, y, highlighted_squares) do
    pos = Position.new(x, y)

    Enum.member?(highlighted_squares, pos)
  end

  defp square(assigns) do
    piece = Board.piece_at(assigns[:game].board, Position.new(assigns[:x], assigns[:y]))

    draggable = piece && piece.color == assigns[:player_color] && !Game.done?(assigns[:game])

    assigns =
      assign(assigns,
        piece: piece,
        draggable: draggable
      )

    ~H"""
    <div
      class={"flex w-[12.5%] h-[12.5%] #{bg_class_for_square(@x, @y, @highlighted)}"}
      draggable={if @draggable, do: "true"}
      data-x={@x}
      data-y={@y}
    >
      <%= if @piece do %>
        <.piece
          color={@piece.color}
          type={@piece.type}
          class={"#{if @draggable, do: "cursor-pointer", else: ""} select-none"}
        />
      <% end %>
    </div>
    """
  end

  defp players(assigns) do
    players =
      if assigns[:player_color] == :white do
        Enum.reverse(assigns[:game].players)
      else
        assigns[:game].players
      end

    active_player = Game.active_player(assigns[:game])

    assigns =
      assign(assigns,
        players: players,
        active_player: active_player
      )

    ~H"""
    <.center>
      <.box>
        <.stack>
          <%= for player <- @players do %>
            <div>
              <%= if player == @active_player do %>
                *
              <% end %>
              <%= player %>
            </div>
          <% end %>
        </.stack>
      </.box>
    </.center>
    """
  end

  defp bg_class_for_square(x, y, highlighted) do
    if rem(x, 2) == rem(y, 2) do
      if highlighted, do: "bg-green-600", else: "bg-gray-600"
    else
      if highlighted, do: "bg-green-400", else: "bg-white"
    end
  end
end
