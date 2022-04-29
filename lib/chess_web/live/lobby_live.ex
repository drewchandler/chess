defmodule ChessWeb.LobbyLive do
  use ChessWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.center>
      <.typography variant="title">Hi, <%= @current_user %>!</.typography>
    </.center>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
