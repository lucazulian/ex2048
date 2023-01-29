defmodule Ex2048.Grid do
  @moduledoc false

  @sides ~w|up down right left|a

  @type grid() :: list(list())
  @type side() ::
          unquote(
            @sides
            |> Enum.map_join(" | ", &inspect/1)
            |> Code.string_to_quoted!()
          )

  @spec new(size :: pos_integer(), obstacles :: pos_integer()) :: grid()
  def new(size, obstacles) when size > 0 and obstacles >= 0 do
    size
    |> make_grid()
    |> randomly_set_cells(2)
    |> randomly_set_obstacles(obstacles)
  end

  @spec move(grid :: grid(), side :: side()) :: {grid(), pos_integer()}
  def move(grid, side)
      when is_list(grid) and side in @sides do
    case try_move(grid, side) do
      :noop ->
        {grid, 0}

      {:ok, grid, points} ->
        {seed(grid), points}
    end
  end

  defp make_grid(size) do
    for _ <- 1..size, do: make_row(size)
  end

  defp make_row(size) do
    for _ <- 1..size, do: 0
  end

  defp randomly_set_cells(grid, number) do
    Enum.reduce(1..number, grid, fn _, acc -> seed(acc) end)
  end

  defp randomly_set_obstacles(grid, 0), do: grid

  defp randomly_set_obstacles(grid, number) do
    Enum.reduce(1..number, grid, fn _, acc -> seed(:o, acc) end)
  end

  defp seed(grid) do
    seed(if(:rand.uniform() < 0.9, do: 2, else: 4), grid)
  end

  defp seed(num, grid) do
    grid
    |> take_empties()
    |> sample()
    |> insert_at(num, grid)
  end

  defp sample({count, empties}) do
    Enum.at(empties, :rand.uniform(count) - 1)
  end

  defp insert_at({row_index, index}, num, grid) do
    List.update_at(grid, row_index, &List.replace_at(&1, index, num))
  end

  defp take_empties(grid) do
    grid
    |> Enum.with_index()
    |> Enum.reduce({0, []}, &take_empties/2)
  end

  defp take_empties({row, row_index}, acc) do
    row
    |> Enum.with_index()
    |> Enum.reduce(acc, fn
      {0, index}, {count, empties} ->
        {count + 1, [{row_index, index} | empties]}

      _cell, acc ->
        acc
    end)
  end

  defp try_move(grid, side) do
    case do_move(grid, side) do
      {^grid, _} ->
        :noop

      {grid, points} ->
        {:ok, grid, points}
    end
  end

  defp do_move(grid, :left) do
    grid
    |> collapse()
    |> compose(&Enum.reverse(&1, &2))
  end

  defp do_move(grid, :right) do
    grid
    |> Enum.map(&Enum.reverse/1)
    |> collapse()
    |> compose(&(&2 ++ &1))
  end

  defp do_move(grid, :up) do
    grid
    |> transpose()
    |> do_move(:left)
    |> transpose
  end

  defp do_move(grid, :down) do
    grid
    |> transpose()
    |> do_move(:right)
    |> transpose()
  end

  defp compose(chunks, fun) do
    Enum.map_reduce(chunks, 0, fn
      {acc, tail, points}, sum ->
        {fun.(acc, tail), sum + points}
    end)
  end

  defp transpose({grid, points}),
    do: {transpose(grid), points}

  defp transpose(grid, acc \\ [])

  defp transpose([[] | _], acc),
    do: Enum.reverse(acc)

  defp transpose(grid, acc) do
    {tail, row} =
      Enum.map_reduce(grid, [], fn
        [el | rest], row -> {rest, [el | row]}
      end)

    transpose(tail, [Enum.reverse(row) | acc])
  end

  defp collapse(grid) do
    grid
    |> Enum.map(fn row ->
      {chunks, points} =
        row
        |> Enum.chunk_by(fn x -> x != :o end)
        |> Enum.map(&collapse(&1, [], []))
        |> compose(&(&2 ++ &1))

      {chunks |> Enum.reverse() |> Enum.concat(), [], points}
    end)
  end

  defp collapse([], acc, tail) do
    acc
    |> Enum.reverse()
    |> merge([], tail, 0)
  end

  defp collapse([0 | rest], acc, tail) do
    collapse(rest, acc, [0 | tail])
  end

  defp collapse([el | rest], acc, tail) do
    collapse(rest, [el | acc], tail)
  end

  defp merge([], acc, tail, points),
    do: {acc, tail, points}

  defp merge([el, el | rest], acc, tail, points) when el != :o do
    sum = el + el
    merge(rest, [sum | acc], [0 | tail], points + sum)
  end

  defp merge([el | rest], acc, tail, points) do
    merge(rest, [el | acc], tail, points)
  end
end
