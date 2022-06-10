defmodule ChessWeb.LobbyLiveTest do
  use ChessWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "GET /" do
    setup do
      user = "drew"
      other_user = "not_drew"

      on_exit(fn ->
        Chess.MatchmakingQueue.leave(user)
        Chess.MatchmakingQueue.leave(other_user)
      end)

      [user: user, other_user: other_user]
    end

    test "redirects if not logged in", %{conn: conn} do
      conn = get(conn, Routes.lobby_path(conn, :index))

      assert redirected_to(conn) == Routes.sign_in_path(conn, :index)
    end

    test "joins the queue when the play button is pressed", %{conn: conn, user: user} do
      {:ok, view, _html} =
        conn
        |> sign_in_user(user)
        |> live(Routes.lobby_path(conn, :index))

      view |> element("[data-test-join-queue]") |> render_click()

      assert has_element?(view, "[data-test-queue-modal]")
    end

    test "pressing cancel leaves the queue", %{conn: conn, user: user} do
      {:ok, view, _html} =
        conn
        |> sign_in_user(user)
        |> live(Routes.lobby_path(conn, :index))

      view |> element("[data-test-join-queue]") |> render_click()
      view |> element("[data-test-leave-queue]") |> render_click()

      refute has_element?(view, "[data-test-queue-modal]")
    end

    test "joining twice shows a dismissable error", %{conn: conn, user: user} do
      {:ok, view, _html} =
        conn
        |> sign_in_user(user)
        |> live(Routes.lobby_path(conn, :index))

      Chess.MatchmakingQueue.join(user, fn _ -> nil end)

      view |> element("[data-test-join-queue]") |> render_click()

      assert has_element?(view, "[data-test-queue-error]", "Already in the queue")

      view |> element("[data-test-dismiss-error]") |> render_click()

      refute has_element?(view, "[data-test-queue-error]")
    end

    test "getting matched with another user redirects to the game", %{
      conn: conn,
      user: user,
      other_user: other_user
    } do
      {:ok, view, _html} =
        conn
        |> sign_in_user(user)
        |> live(Routes.lobby_path(conn, :index))

      me = self()
      Chess.MatchmakingQueue.join(other_user, fn game_name -> send(me, {:matched, game_name}) end)

      view |> element("[data-test-join-queue]") |> render_click()

      game_name =
        receive do
          {:matched, game_name} -> game_name
        end

      assert_redirect(view, Routes.game_path(conn, :show, game_name))
    end
  end
end
