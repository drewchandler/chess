defmodule ChessWeb.SessionControllerTest do
  use ChessWeb.ConnCase, async: true

  describe "POST /session" do
    test "logs the user in", %{conn: conn} do
      username = "drew"

      conn =
        post(conn, Routes.session_path(conn, :create), %{"user" => %{"username" => username}})

      assert get_session(conn, :current_user) == username
      assert redirected_to(conn) == Routes.lobby_path(conn, :index)
    end
  end

  describe "DELETE /session" do
    test "logs the user out", %{conn: conn} do
      conn = conn |> log_in_user("drew") |> delete(Routes.session_path(conn, :destroy))

      assert redirected_to(conn) == Routes.sign_in_path(conn, :index)
      refute get_session(conn, :current_user)
    end
  end
end
