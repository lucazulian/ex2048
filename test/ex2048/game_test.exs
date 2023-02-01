defmodule Ex2048.GameTest do
  use ExUnit.Case, async: true

  alias Ex2048.Game

  @grid [
    [4, 0, 2, 2, 2],
    [2, 2, 4, 4, 4],
    [2, 0, 2, 2, 0],
    [0, 2, 0, 2, 0],
    [0, 2, 0, 2, 0]
  ]

  for side <- ~w|up down right left|a do
    test "move #{side}" do
      {:ok, game_id} = Game.new(@grid)

      assert Game.pick(game_id) == %Game{grid: @grid, score: 0}

      :ok = Game.move(game_id, unquote(side))

      assert Game.pick(game_id) != %Game{grid: @grid, score: 0}
    end
  end

  describe "exists?/1" do
    test "should return false with non existing game" do
      refute Game.exists?("game_id")
    end

    test "should return false with existing game" do
      {:ok, game_id} = Game.new(4, 1)
      assert Game.exists?(game_id)
    end
  end
end
