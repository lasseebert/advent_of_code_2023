defmodule Advent.Day18Test do
  use Advent.Test.Case

  alias Advent.Day18

  @example_input """
  R 6 (#70c710)
  D 5 (#0dc571)
  L 2 (#5713f0)
  D 2 (#d2c081)
  R 2 (#59c680)
  D 2 (#411b91)
  L 5 (#8ceee2)
  U 2 (#caa173)
  L 1 (#1b58a2)
  U 2 (#caa171)
  R 2 (#7807d2)
  U 3 (#a77fa3)
  L 2 (#015232)
  U 2 (#7a21e3)
  """

  @puzzle_input File.read!("puzzle_inputs/day_18.txt")

  describe "part 1" do
    test "example" do
      assert Day18.part_1(@example_input) == 62
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day18.part_1(@puzzle_input) == 72_821
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day18.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day18.part_2(@puzzle_input) == :foo
    end
  end
end
