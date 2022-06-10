defmodule ChessWeb.LobbyLive do
  use ChessWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <%= cond do %>
      <% @in_queue -> %>
        <.modal data-test-queue-modal>
          <.stack>
            <.spinner />
            <.button phx-click="leave-queue" data-test-leave-queue>Cancel</.button>
          </.stack>
        </.modal>
      <% @error -> %>
        <.modal>
          <.stack>
            <span data-test-queue-error><%= @error %></span>
            <.button phx-click="dismiss-error" data-test-dismiss-error>Ok</.button>
          </.stack>
        </.modal>
      <% true -> %>
        <.center>
          <.button size="6xl" phx-click="join-queue" data-test-join-queue>Play</.button>
        </.center>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, in_queue: false, error: nil)}
  end

  @impl true
  def handle_event("join-queue", _, socket) do
    me = self()

    case Chess.MatchmakingQueue.join(socket.assigns[:current_user], fn game_name ->
           send(me, {:matched, game_name})
         end) do
      :ok -> {:noreply, assign(socket, in_queue: true)}
      {:error, error} -> {:noreply, assign(socket, error: error)}
    end
  end

  @impl true
  def handle_event("leave-queue", _, socket) do
    Chess.MatchmakingQueue.leave(socket.assigns[:current_user])

    {:noreply, assign(socket, in_queue: false)}
  end

  @impl true
  def handle_event("dismiss-error", _, socket) do
    {:noreply, assign(socket, error: nil)}
  end

  @impl true
  def handle_info({:matched, game_name}, socket) do
    {:noreply, push_redirect(socket, to: Routes.game_path(socket, :show, game_name))}
  end

  @impl true
  def terminate({:shutdown, _}, socket) do
    if socket.assigns[:in_queue] do
      Chess.MatchmakingQueue.leave(socket.assigns[:current_user])
    end

    :ok
  end
end
