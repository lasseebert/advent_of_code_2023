defmodule Advent.Day13Test do
  use Advent.Test.Case

  alias Advent.Day13

  @example_input """
  #.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.

  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
  """

  @puzzle_input File.read!("puzzle_inputs/day_13.txt")

  describe "part 1" do
    test "example" do
      assert Day13.part_1(@example_input) == 405
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day13.part_1(@puzzle_input) == 34_889
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day13.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day13.part_2(@puzzle_input) == :foo
    end
  end
end
