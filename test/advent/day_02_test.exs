defmodule Advent.Day02Test do
  use Advent.Test.Case

  alias Advent.Day02

  @example_input """
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  """

  @puzzle_input File.read!("puzzle_inputs/day_02.txt")

  describe "part 1" do
    test "example" do
      assert Day02.part_1(@example_input) == 8
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day02.part_1(@puzzle_input) == 2685
    end
  end

  describe "part 2" do
    test "example" do
      assert Day02.part_2(@example_input) == 2286
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day02.part_2(@puzzle_input) == 83_707
    end
  end
end
