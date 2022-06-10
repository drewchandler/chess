defmodule ChessWeb.GameLiveTest do
  use ChessWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "GET /game/:id" do
    test "redirects if not logged in", %{conn: conn} do
      conn = get(conn, Routes.game_path(conn, :show, "name"))

      assert redirected_to(conn) == Routes.sign_in_path(conn, :index)
    end

    test "shows an error if the game does not exist", %{conn: conn} do
      {:ok, view, _html} = sign_in_and_join_game(conn, "user", "does-not-exist")

      assert has_element?(view, "[data-test-game-error-modal]")

      view |> element("[data-test-go-back-to-lobby]") |> render_click()

      assert_patch(view, Routes.lobby_path(conn, :index))
    end

    test "players can make moves" do
      [white_player_view, black_player_view] = create_views_for_two_player_game()

      white_player_view
      |> element("#board")
      |> render_hook("move", %{"from" => %{"x" => 0, "y" => 1}, "to" => %{"x" => 0, "y" => 2}})

      assert has_element?(
               white_player_view,
               "[data-x='0'][data-y='2'] [data-test-piece='white pawn']"
             )

      black_player_view
      |> element("#board")
      |> render_hook("move", %{"from" => %{"x" => 0, "y" => 6}, "to" => %{"x" => 0, "y" => 5}})

      assert has_element?(
               black_player_view,
               "[data-x='0'][data-y='5'] [data-test-piece='black pawn']"
             )
    end

    @tag capture_log: true
    test "winner is shown when the game is over" do
      [white_player_view, black_player_view] = create_views_for_two_player_game()

      white_player_view
      |> element("#board")
      |> render_hook("move", %{"from" => %{"x" => 5, "y" => 1}, "to" => %{"x" => 5, "y" => 2}})

      black_player_view
      |> element("#board")
      |> render_hook("move", %{"from" => %{"x" => 4, "y" => 6}, "to" => %{"x" => 4, "y" => 5}})

      white_player_view
      |> element("#board")
      |> render_hook("move", %{"from" => %{"x" => 6, "y" => 1}, "to" => %{"x" => 6, "y" => 3}})

      black_player_view
      |> element("#board")
      |> render_hook("move", %{"from" => %{"x" => 3, "y" => 7}, "to" => %{"x" => 7, "y" => 3}})

      assert has_element?(black_player_view, "[data-test-result-message]")
      assert has_element?(white_player_view, "[data-test-result-message]")
    end

    test "players can hover pieces to see legal moves" do
      [white_player_view, black_player_view] = create_views_for_two_player_game()

      white_player_view
      |> element("#board")
      |> render_hook("get-moves", %{"x" => 0, "y" => 1})

      assert has_element?(white_player_view, "[data-x='0'][data-y='2'][data-test-highlighted]")
      assert has_element?(white_player_view, "[data-x='0'][data-y='3'][data-test-highlighted]")

      refute has_element?(black_player_view, "[data-x='0'][data-y='2'][data-test-highlighted]")
      refute has_element?(black_player_view, "[data-x='0'][data-y='3'][data-test-highlighted]")
    end

    test "highlighted moves can be cleared" do
      [white_player_view, _] = create_views_for_two_player_game()

      white_player_view
      |> element("#board")
      |> tap(&render_hook(&1, "get-moves", %{"x" => 0, "y" => 1}))
      |> render_hook("clear-moves")

      refute has_element?(white_player_view, "[data-x='0'][data-y='2'][data-test-highlighted]")
      refute has_element?(white_player_view, "[data-x='0'][data-y='3'][data-test-highlighted]")
    end

    def sign_in_and_join_game(conn, user, game_name) do
      conn
      |> sign_in_user(user)
      |> live(Routes.game_path(conn, :show, game_name))
    end

    def create_views_for_two_player_game() do
      player1 = "player1"
      player2 = "player2"

      game_name = Chess.GameMaster.start_game([player1, player2])

      player1_conn = Phoenix.ConnTest.build_conn()
      {:ok, player1_view, _html} = sign_in_and_join_game(player1_conn, player1, game_name)

      player2_conn = Phoenix.ConnTest.build_conn()
      {:ok, player2_view, _html} = sign_in_and_join_game(player2_conn, player2, game_name)

      player1_view
      |> element("[data-test-active-player]")
      |> render()
      |> then(fn view ->
        if view =~ player1 do
          [player1_view, player2_view]
        else
          [player2_view, player1_view]
        end
      end)
    end
  end
end
