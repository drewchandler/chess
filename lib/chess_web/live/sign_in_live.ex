defmodule ChessWeb.SignInLive do
  use ChessWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.center>
      <.stack>
        <.center>
          <.piece color="black" type="knight" />
        </.center>

        <.center>
          <.typography variant="title" gutter="4">Chess</.typography>
        </.center>

        <.box>
          <.form
            let={f}
            for={:user}
            action={Routes.session_path(@socket, :create)}
            phx-submit="validate"
            phx-trigger-action={@trigger_submit}
          >
            <.stack gap={true}>
              <.input form={f} field={:username} value={@username} />

              <.button>Sign In</.button>
            </.stack>
          </.form>
        </.box>
      </.stack>
    </.center>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, username: "", trigger_submit: false)}
  end

  @impl true
  def handle_event("validate", %{"user" => %{"username" => username}}, socket) do
    username
    |> String.trim()
    |> case do
      "" -> {:noreply, assign(socket, username: "")}
      u -> {:noreply, assign(socket, username: u, trigger_submit: true)}
    end
  end
end
