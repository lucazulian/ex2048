defmodule Ex2048Web.GameLive.Index do
  use Ex2048Web, :live_view

  alias Ex2048.Game

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:game, Game.new())}
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _uri, socket) do
    case Registry.lookup(Ex2048.GameRegistry, id) do
      [_] ->
        :ok = Phoenix.PubSub.subscribe(Ex2048.PubSub, id)
        {:noreply, assign_game(socket, id)}

      _ ->
        {:noreply, assign(socket, game: %Game{})}
    end
  end

  def handle_params(_params, _uri, socket) do
    {:ok, id} = create_new_game()

    {:noreply, push_redirect(socket, to: "/#{id}", replace: true)}
  end

  @impl true
  def handle_event("new_game", _value, socket) do
    {:ok, id} = create_new_game()

    {:noreply, push_redirect(socket, to: "/#{id}", replace: true)}
  end

  def handle_event("update_grid", %{"key" => key_code}, %{assigns: %{id: id}} = socket) do
    case move_from_key_code(key_code, id) do
      :ok ->
        :ok = Phoenix.PubSub.broadcast(Ex2048.PubSub, id, :update)

      _ ->
        {:noreply, put_flash(socket, :error, "invalid key pressed")}
    end

    {:noreply, socket}
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, assign_game(socket)}
  end

  defp via_tuple(id) do
    {:via, Registry, {Ex2048.GameRegistry, id}}
  end

  defp assign_game(socket, id) do
    socket
    |> assign(id: id)
    |> assign_game()
  end

  defp assign_game(%{assigns: %{id: id}} = socket) do
    game = GenServer.call(via_tuple(id), :game)
    assign(socket, game: game)
  end

  defp create_new_game do
    id =
      ?a..?z
      |> Enum.take_random(20)
      |> List.to_string()

    case DynamicSupervisor.start_child(Ex2048.GameSupervisor, {Game, name: via_tuple(id)}) do
      {:ok, _pid} ->
        {:ok, id}

      error ->
        error
    end
  end

  defp move_from_key_code("ArrowLeft", id), do: move(id, :left)

  defp move_from_key_code("ArrowUp", id), do: move(id, :up)

  defp move_from_key_code("ArrowRight", id), do: move(id, :right)

  defp move_from_key_code("ArrowDown", id), do: move(id, :down)

  defp move_from_key_code(_, _), do: {:error, :invalid_key_code}

  defp move(id, side) do
    GenServer.cast(via_tuple(id), side)
  end
end
