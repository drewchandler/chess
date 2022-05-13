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
    assigns = assign(assigns, gap_class: gap_class(assigns[:gap]))

    ~H"""
    <div class={"grid #{@gap_class}"}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def split(assigns) do
    assigns =
      assign(assigns, grid_template_columns_class: grid_template_columns_class(assigns[:fraction]))

    ~H"""
    <div class={"grid #{@grid_template_columns_class}"}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp gap_class("6"), do: "gap-6"
  defp gap_class(nil), do: "gap-0"

  defp grid_template_columns_class("3/4"), do: "grid-cols-[3fr_1fr]"
  defp grid_template_columns_class(nil), do: "grid-cols-[1fr_1fr]"
end
