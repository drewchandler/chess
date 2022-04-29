defmodule ChessWeb.SessionController do
  use ChessWeb, :controller

  alias ChessWeb.UserAuth

  def create(conn, %{"user" => %{"username" => username}}) do
    UserAuth.sign_in_user(conn, username)
  end

  def destroy(conn, _) do
    UserAuth.sign_out_user(conn)
  end
end
