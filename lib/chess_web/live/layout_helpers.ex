defmodule ChessWeb.LayoutHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  def center(assigns) do
    ~H"""
    <div class="w-full h-full flex flex-col items-center justify-center">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def stack(assigns) do
    assigns = assign_new(assigns, :gap, fn -> false end)

    ~H"""
    <div class={"grid #{if @gap, do: "gap-6", else: ""}"}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
