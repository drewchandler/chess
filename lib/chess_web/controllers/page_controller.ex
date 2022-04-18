defmodule ChessWeb.PageController do
  use ChessWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:page_title, "Index")
    |> render("index.html")
  end
end
