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
        <%= text_input(@form, @field, [class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"] ++ @input_options) %>
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

  def button(assigns) do
    button_options = assigns_to_attributes(assigns, [])

    ~H"""
    <button class="border bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline" {button_options}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  def typography(assigns) do
    assigns =
      assign(
        assigns,
        text_class:
          case assigns[:variant] do
            "title" -> "text-4xl"
            _ -> "text-md"
          end,
        margin_class:
          case assigns[:gutter] do
            "4" -> "mb-4"
            _ -> "mb-0"
          end
      )

    ~H"""
    <span class={"#{@text_class} #{@margin_class}"}>
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
    <%= Phoenix.HTML.Link.link @link_options do%>
      <%= render_slot(@inner_block) %>
    <% end %>
    """
  end

  def sign_out_path() do
    Routes.session_path(Endpoint, :destroy)
  end
end
