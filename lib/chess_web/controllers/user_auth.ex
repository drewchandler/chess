defmodule ChessWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Phoenix.LiveView
  alias ChessWeb.Router.Helpers, as: Routes

  def on_mount(:ensure_unauthenticated, _params, session, socket) do
    case session do
      %{"current_user" => _} ->
        {:halt, redirect_to_signed_in(socket)}

      _ ->
        {:cont, LiveView.assign(socket, :current_user, nil)}
    end
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    case session do
      %{"current_user" => username} ->
        {:cont, LiveView.assign(socket, :current_user, username)}

      _ ->
        {:halt, redirect_to_sign_in(socket)}
    end
  end

  def redirect_to_sign_in(socket) do
    LiveView.redirect(socket, to: sign_in_path(socket))
  end

  def redirect_to_signed_in(socket) do
    LiveView.redirect(socket, to: signed_in_path(socket))
  end

  def sign_in_user(conn, username) do
    conn
    |> put_session(:current_user, username)
    |> put_session(:live_socket_id, "user_sessions:#{username}")
    |> redirect(to: signed_in_path(conn))
  end

  def sign_out_user(conn) do
    if live_socket_id = get_session(conn, :live_socket_id) do
      ChessWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> redirect(to: sign_in_path(conn))
  end

  def signed_in_path(conn_or_socket) do
    Routes.lobby_path(conn_or_socket, :index)
  end

  def sign_in_path(conn_or_socket) do
    Routes.sign_in_path(conn_or_socket, :index)
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
