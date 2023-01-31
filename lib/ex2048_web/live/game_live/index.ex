defmodule Ex2048Web.GameLive.Index do
  use Ex2048Web, :live_view

  alias Ex2048.Game

  @default_size 6
  @default_obstacles 0

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:game, %{})
     |> assign(:size, @default_size)
     |> assign(:obstacles, @default_obstacles)}
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _uri, socket) do
    if Game.exists?(id) do
      :ok = Phoenix.PubSub.subscribe(Ex2048.PubSub, id)
      {:noreply, assign_game(socket, id)}
    else
      {:noreply, socket |> assign(game: nil) |> put_flash(:error, "game not found")}
    end
  end

  def handle_params(_params, _uri, socket) do
    {:ok, id} = Game.new(@default_size, @default_obstacles)
    {:noreply, push_redirect(socket, to: "/game/#{id}", replace: true)}
  end

  @impl true
  def handle_event(
        "new_game",
        %{"game_settings" => %{"size" => size_input, "obstacles" => obstacles_input}},
        socket
      ) do
    with {size, ""} <- Integer.parse(size_input),
         {obstacles, ""} <- Integer.parse(obstacles_input) do
      {:ok, id} = Game.new(size, obstacles)
      {:noreply, push_redirect(socket, to: "/game/#{id}", replace: true)}
    else
      _ ->
        {:noreply, socket |> assign(game: nil) |> put_flash(:error, "invalid input")}
    end
  end

  def handle_event("update_grid", %{"key" => key_code}, %{assigns: %{id: id}} = socket) do
    case move_from_key_code(key_code, id) do
      :ok ->
        :ok = Phoenix.PubSub.broadcast(Ex2048.PubSub, id, :update)
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, assign_game(socket)}
  end

  defp assign_game(socket, id) do
    socket
    |> assign(id: id)
    |> assign_game()
  end

  defp assign_game(%{assigns: %{id: id}} = socket) do
    assign(socket, game: Game.pick(id))
  end

  defp move_from_key_code("ArrowLeft", id), do: Game.move(id, :left)
  defp move_from_key_code("ArrowUp", id), do: Game.move(id, :up)
  defp move_from_key_code("ArrowRight", id), do: Game.move(id, :right)
  defp move_from_key_code("ArrowDown", id), do: Game.move(id, :down)
  defp move_from_key_code(_, _), do: {:error, :invalid_key_code}
end
