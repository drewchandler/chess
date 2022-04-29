defmodule ChessWeb.Router do
  use ChessWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ChessWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ChessWeb do
    pipe_through :browser

    post "/session", SessionController, :create
    delete "/session", SessionController, :destroy

    live_session(:unauthenticated,
      on_mount: [{ChessWeb.UserAuth, :ensure_unauthenticated}]
    ) do
      live "/sign-in", SignInLive, :index
    end

    live_session(:authenticated,
      on_mount: [{ChessWeb.UserAuth, :ensure_authenticated}]
    ) do
      live "/", LobbyLive, :index
    end
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ChessWeb.Telemetry
    end
  end
end
