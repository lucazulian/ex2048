defmodule Ex2048.GridTest do
  use ExUnit.Case, async: true

  alias Ex2048.Grid

  describe "grid without obstacles" do
    setup do
      :rand.seed(:exsss, {123, 123_534, 345_345})

      {:ok,
       grid: [
         [4, 0, 2, 2, 2],
         [2, 2, 4, 4, 4],
         [2, 0, 2, 2, 0],
         [0, 2, 0, 2, 0],
         [0, 2, 0, 2, 0]
       ]}
    end

    test "new/1" do
      assert Grid.new(2, 0) == [[0, 4], [2, 0]]
      assert Grid.new(2, 0) == [[0, 0], [2, 2]]
    end

    test "move/2 left side", %{grid: grid} do
      assert Grid.move(grid, :left) ==
               {[
                  [4, 4, 2, 0, 0],
                  [4, 8, 4, 0, 0],
                  [4, 2, 0, 0, 0],
                  [4, 0, 0, 4, 0],
                  [4, 0, 0, 0, 0]
                ], 28}
    end

    test "move/2 right side", %{grid: grid} do
      assert Grid.move(grid, :right) ==
               {[
                  [0, 0, 4, 2, 4],
                  [0, 0, 4, 4, 8],
                  [0, 0, 0, 2, 4],
                  [0, 0, 4, 0, 4],
                  [0, 0, 0, 0, 4]
                ], 28}
    end

    test "move/2 up side", %{grid: grid} do
      assert Grid.move(grid, :up) ==
               {[
                  [4, 4, 2, 2, 2],
                  [4, 2, 4, 4, 4],
                  [0, 0, 2, 4, 0],
                  [0, 0, 0, 2, 0],
                  [0, 0, 4, 0, 0]
                ], 12}
    end

    test "move/2 down side", %{grid: grid} do
      assert Grid.move(grid, :down) ==
               {[
                  [0, 0, 0, 0, 0],
                  [0, 0, 0, 2, 0],
                  [4, 0, 2, 4, 0],
                  [4, 2, 4, 2, 2],
                  [4, 4, 2, 4, 4]
                ], 12}
    end

    test "make/2 no points" do
      grid = [[0, 0], [2, 4]]

      assert Grid.move(grid, :left) == {grid, 0}
    end
  end

  describe "grid with obstacles" do
    setup do
      :rand.seed(:exsss, {123, 345_345, 123_534})

      {:ok,
       grid: [
         [4, 0, :o, 2, 2],
         [2, :o, 2, 4, 4],
         [2, 0, 2, 2, 0],
         [0, 2, 0, :o, 0],
         [0, 2, 0, 2, 0]
       ]}
    end

    test "new/1" do
      assert Grid.new(3, 1) == [[0, 0, 2], [0, 0, 2], [0, :o, 0]]
      assert Grid.new(3, 2) == [[0, 2, :o], [0, :o, 0], [0, 2, 0]]
    end

    test "move/2 left side", %{grid: grid} do
      assert Grid.move(grid, :left) ==
               {[
                  [4, 0, :o, 4, 0],
                  [2, :o, 2, 8, 0],
                  [4, 2, 2, 0, 0],
                  [2, 0, 0, :o, 0],
                  [4, 0, 0, 0, 0]
                ], 20}
    end

    test "move/2 right side", %{grid: grid} do
      assert Grid.move(grid, :right) ==
               {[
                  [0, 4, :o, 0, 4],
                  [2, :o, 0, 2, 8],
                  [2, 0, 0, 2, 4],
                  [0, 0, 2, :o, 0],
                  [0, 0, 0, 0, 4]
                ], 20}
    end

    test "move/2 up side", %{grid: grid} do
      assert Grid.move(grid, :up) ==
               {[
                  [4, 0, :o, 2, 2],
                  [4, :o, 4, 4, 4],
                  [0, 4, 0, 2, 0],
                  [0, 0, 0, :o, 0],
                  [2, 0, 0, 2, 0]
                ], 12}
    end

    test "move/2 down side", %{grid: grid} do
      assert Grid.move(grid, :down) ==
               {[
                  [0, 0, :o, 2, 0],
                  [0, :o, 0, 4, 0],
                  [0, 0, 2, 2, 0],
                  [4, 0, 0, :o, 2],
                  [4, 4, 4, 2, 4]
                ], 12}
    end

    test "make/2 no points" do
      grid = [[0, :o, 0], [2, :o, 4], [0, 0, 0]]

      assert Grid.move(grid, :left) == {grid, 0}
    end
  end
end
