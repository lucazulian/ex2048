defmodule Ex2048.Game do
  @moduledoc false

  defstruct grid: [], score: 0

  use GenServer

  alias Ex2048.Grid

  def start_link(options) do
    size = Keyword.get(options, :game_size)
    obstacles = Keyword.get(options, :game_obstacles)

    GenServer.start_link(__MODULE__, new(size, obstacles), options)
  end

  @impl true
  def init(game) do
    {:ok, game}
  end

  @impl true
  def handle_call(:game, _from, game) do
    {:reply, game, game}
  end

  @impl true
  def handle_cast(:left, game) do
    {:noreply, step(game, :left)}
  end

  @impl true
  def handle_cast(:right, game) do
    {:noreply, step(game, :right)}
  end

  @impl true
  def handle_cast(:up, game) do
    {:noreply, step(game, :up)}
  end

  @impl true
  def handle_cast(:down, game) do
    {:noreply, step(game, :down)}
  end

  def new(size, obstacles) when size > 0 and obstacles >= 0 do
    %__MODULE__{grid: Grid.new(size, obstacles)}
  end

  defp step(%{grid: grid, score: score}, side) do
    {grid, points} = Grid.move(grid, side)
    %__MODULE__{grid: grid, score: score + points}
  end
end
