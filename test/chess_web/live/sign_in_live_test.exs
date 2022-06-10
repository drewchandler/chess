defmodule ChessWeb.SignInLiveTest do
  use ChessWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "GET /sign-in" do
    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> sign_in_user("drew") |> get(Routes.sign_in_path(conn, :index))

      assert redirected_to(conn) == Routes.lobby_path(conn, :index)
    end

    test "logs the user in", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.sign_in_path(conn, :index))

      form_data = %{"user" => %{"username" => "drew"}}

      conn =
        view
        |> form("[data-test-form='sign-in']", form_data)
        |> tap(&render_submit/1)
        |> follow_trigger_action(conn)

      assert conn.request_path == Routes.session_path(conn, :create)
      assert conn.method == "POST"
      assert conn.params == form_data
    end

    test "does not log the user in if the username is blank", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.sign_in_path(conn, :index))

      view
      |> form("[data-test-form='sign-in']", %{user: %{username: ""}})
      |> render_submit()

      refute has_element?(view, "[data-test-form='sign-in'][phx-trigger-action]")
    end
  end
end
