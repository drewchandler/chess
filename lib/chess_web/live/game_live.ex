defmodule ChessWeb.GameLive do
  use ChessWeb, :live_view

  alias Chess.{GameSession, Rules.Board, Rules.Piece, Rules.Position}

  @impl true
  def render(assigns) do
    ~H"""
    <%= if @error do %>
      <.modal>
        <.stack gap="6">
          <%= @error %>
          
          <.button>Back</.button>
        </.stack>
      </.modal>
    <% else %>
      <.game game={@game} />
    <% end %>
    """
  end

  @impl true
  def mount(%{"id" => name}, _session, socket) do
    if GameSession.exists?(name) do
      {:ok, assign(socket, game: GameSession.current_state(name), error: nil)}
    else
      {:ok, assign(socket, game: nil, error: "Game does not exist")}
    end
  end

  defp game(assigns) do
    assigns =
      assign(assigns,
        player_color: color_for_player(assigns[:current_user], assigns[:game].players)
      )

    ~H"""
    <.center>
      <.split fraction="3/4">
        <.board board={@game.board} player_color={@player_color} />
        <.players players={@game.players} player_color={@player_color} />
      </.split>
    </.center>
    """
  end

  defp board(assigns) do
    squares = for row <- 0..7, col <- 0..7, do: [row, col]

    squares =
      if assigns[:player_color] == :white do
        Enum.reverse(squares)
      else
        squares
      end

    assigns = assign(assigns, squares: squares)

    ~H"""
    <.center>
      <div class="flex flex-wrap w-[75vmin] h-[75vmin]">
        <%= for [row, col] <- @squares do %>
          <.square board={@board} row={row} col={col} />
        <% end %>
      </div>
    </.center>
    """
  end

  defp square(assigns) do
    assigns =
      assign(assigns,
        piece: Board.piece_at(assigns[:board], Position.new(assigns[:col], assigns[:row]))
      )

    ~H"""
    <div class={"flex w-[12.5%] h-[12.5%] #{bg_class_for_square(@row, @col)}"}>
      <%= if @piece do %>
          <.piece color={@piece.color} type={@piece.type} />
      <% end %>
    </div>
    """
  end

  defp players(assigns) do
    assigns =
      assign(assigns,
        players:
          if assigns[:player_color] == :white do
            Enum.reverse(assigns[:players])
          else
            assigns[:players]
          end
      )

    ~H"""
    <div>
      <%= for player <- @players do %>
        <div>
          <%= player %>
        </div>
      <% end %>
    </div>
    """
  end

  defp bg_class_for_square(row, col) do
    if rem(row, 2) == rem(col, 2) do
      "bg-gray-600 hover:bg-green-600"
    else
      "bg-white hover:bg-green-400"
    end
  end

  defp color_for_player(player, [player, _]), do: :white
  defp color_for_player(_, _), do: :black
end
