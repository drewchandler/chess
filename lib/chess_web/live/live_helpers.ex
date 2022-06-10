defmodule ChessWeb.LiveHelpers do
  import Phoenix.HTML.Form
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import ChessWeb.LayoutHelpers

  alias ChessWeb.Router.Helpers, as: Routes
  alias ChessWeb.Endpoint

  def piece(assigns) do
    svg_options = assigns_to_attributes(assigns, [:color, :type])
    assigns = assign(assigns, svg_options: svg_options)

    ~H"""
    <svg {@svg_options}>
      <use href={Routes.static_path(Endpoint, "/assets/images/chess_pieces.svg##{@color}-#{@type}")} />
    </svg>
    """
  end

  def input(assigns) do
    input_options = assigns_to_attributes(assigns, [:form, :field])
    assigns = assign(assigns, input_options: input_options)

    ~H"""
    <.stack>
      <%= label(@form, @field, class: "block text-gray-700 text-sm font-bold mb-2") %>
      <%= text_input(
        @form,
        @field,
        [
          class:
            "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
        ] ++ @input_options
      ) %>
    </.stack>
    """
  end

  def box(assigns) do
    ~H"""
    <div class="border border-gray-700 bg-white p-4 rounded shadow">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def button(assigns = %{patch: _}) do
    button_options = assigns_to_attributes(assigns, [:patch, :size])
    button_styles = button_styles(assigns)
    assigns = assign(assigns, button_options: button_options, button_styles: button_styles)

    ~H"""
    <%= live_patch [to: @patch, class: @button_styles] ++ @button_options do %>
      <%= render_slot(@inner_block) %>
    <% end %>
    """
  end

  def button(assigns) do
    button_options = assigns_to_attributes(assigns, [:size])
    button_styles = button_styles(assigns)

    assigns = assign(assigns, button_options: button_options, button_styles: button_styles)

    ~H"""
    <button class={@button_styles} {@button_options}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  def typography(assigns) do
    assigns =
      assign(
        assigns,
        text_class: text_class(assigns[:variant]),
        text_align_class: text_align_class(assigns[:text_align]),
        margin_class: margin_class(assigns[:gutter])
      )

    ~H"""
    <span class={"#{@text_class} #{@text_align_class} #{@margin_class}"}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  def link(assigns) do
    link_options =
      assigns
      |> assigns_to_attributes([:href])
      |> Keyword.put(:to, assigns[:href] || "#")

    assigns = assign(assigns, link_options: link_options)

    ~H"""
    <%= Phoenix.HTML.Link.link @link_options do %>
      <%= render_slot(@inner_block) %>
    <% end %>
    """
  end

  def modal(assigns) do
    options = assigns_to_attributes(assigns)
    assigns = assign(assigns, options: options)

    ~H"""
    <.center {@options}>
      <.box>
        <%= render_slot(@inner_block) %>
      </.box>
    </.center>
    """
  end

  def spinner(assigns) do
    ~H"""
    <img src={Routes.static_path(Endpoint, "/assets/images/loading.svg")} />
    """
  end

  def sign_out_path() do
    Routes.session_path(Endpoint, :destroy)
  end

  defp button_styles(assigns) do
    base_styles =
      "border bg-blue-500 hover:bg-blue-700 text-center text-white font-bold rounded focus:outline-none focus:shadow-outline"

    additional_styles =
      case assigns[:size] do
        "6xl" -> "text-6xl py-8 px-24"
        _ -> "py-2 px-4"
      end

    Enum.join([base_styles, additional_styles], " ")
  end

  defp text_class("title"), do: "text-4xl"
  defp text_class("error"), do: "text-xl text-red-700"

  defp text_align_class("center"), do: "text-center"
  defp text_align_class(nil), do: ""

  defp margin_class("4"), do: "mb-4"
  defp margin_class(_), do: "mb-0"
end
