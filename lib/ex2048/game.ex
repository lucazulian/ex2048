defmodule Ex2048.Game do
  @moduledoc false

  defstruct grid: [], score: 0

  use GenServer

  alias Ex2048.Grid

  @spec exists?(String.t()) :: boolean()
  def exists?(id) do
    case Registry.lookup(Ex2048.GameRegistry, id) do
      [_] ->
        true

      _ ->
        false
    end
  end

  @spec pick(id :: String.t()) :: term
  def pick(id) do
    GenServer.call(via_tuple(id), :pick)
  end

  @spec new(size :: pos_integer(), obstacles :: integer()) ::
          {:ok, String.t()}
          | :ignore
          | {:error, {:already_started, pid()} | :max_children | term()}
  @spec new(grid :: Grid.t()) ::
          {:ok, String.t()}
          | :ignore
          | {:error, {:already_started, pid()} | :max_children | term()}
  def new(size, obstacles) when size > 0 and obstacles >= 0 do
    size
    |> Grid.new(obstacles)
    |> build()
  end

  def new(grid) do
    build(grid)
  end

  @spec move(id :: String.t(), side :: Grid.side()) :: :ok
  def move(id, side) do
    GenServer.cast(via_tuple(id), side)
  end

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(options) do
    grid = Keyword.get(options, :grid)
    GenServer.start_link(__MODULE__, %__MODULE__{grid: grid}, options)
  end

  @impl true
  def init(game) do
    {:ok, game}
  end

  @impl true
  def handle_call(:pick, _from, game) do
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

  defp build(grid) do
    id =
      ?a..?z
      |> Enum.take_random(20)
      |> List.to_string()

    case DynamicSupervisor.start_child(
           Ex2048.GameSupervisor,
           {__MODULE__, name: via_tuple(id), grid: grid}
         ) do
      {:ok, _pid} ->
        {:ok, id}

      error ->
        error
    end
  end

  defp step(%{grid: grid, score: score}, side) do
    {grid, points} = Grid.move(grid, side)
    %__MODULE__{grid: grid, score: score + points}
  end

  defp via_tuple(id) do
    {:via, Registry, {Ex2048.GameRegistry, id}}
  end
end
