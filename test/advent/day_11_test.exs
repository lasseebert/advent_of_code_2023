defmodule Advent.Day11Test do
  use Advent.Test.Case

  alias Advent.Day11

  @example_input """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """

  @puzzle_input File.read!("puzzle_inputs/day_11.txt")

  describe "part 1" do
    test "example" do
      assert Day11.part_1(@example_input) == 374
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day11.part_1(@puzzle_input) == 9_418_609
    end
  end

  describe "part 2" do
    test "example 1" do
      assert Day11.part_2(@example_input, 10) == 1030
    end

    test "example 2" do
      assert Day11.part_2(@example_input, 100) == 8410
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day11.part_2(@puzzle_input, 1_000_000) == 593_821_230_983
    end
  end
end
