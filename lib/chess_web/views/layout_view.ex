defmodule ChessWeb.LayoutView do
  use ChessWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def render_layout(layout, assigns, do: content) do
    render(layout, Map.put(assigns, :inner_layout, content))
  end
end
