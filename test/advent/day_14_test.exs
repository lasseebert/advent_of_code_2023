defmodule Advent.Day14Test do
  use Advent.Test.Case

  alias Advent.Day14

  @example_input """
  O....#....
  O.OO#....#
  .....##...
  OO.#O....O
  .O.....O#.
  O.#..O.#.#
  ..O..#O..O
  .......O..
  #....###..
  #OO..#....
  """

  @puzzle_input File.read!("puzzle_inputs/day_14.txt")

  describe "part 1" do
    test "example" do
      assert Day14.part_1(@example_input) == 136
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day14.part_1(@puzzle_input) == 108_935
    end
  end

  describe "part 2" do
    test "example" do
      assert Day14.part_2(@example_input) == 64
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day14.part_2(@puzzle_input) == 100_876
    end
  end
end
