defmodule ChessWeb.Router do
  use ChessWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ChessWeb do
    pipe_through :api
  end
end
