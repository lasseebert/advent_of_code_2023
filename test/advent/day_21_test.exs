defmodule Advent.Day21Test do
  use Advent.Test.Case

  alias Advent.Day21

  @example_input """
  ...........
  .....###.#.
  .###.##..#.
  ..#.#...#..
  ....#.#....
  .##..S####.
  .##..#...#.
  .......##..
  .##.#.####.
  .##..##.##.
  ...........
  """

  @puzzle_input File.read!("puzzle_inputs/day_21.txt")

  describe "part 1" do
    test "example" do
      assert Day21.part_1(@example_input, 6) == 16
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_1(@puzzle_input) == 3615
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day21.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_2(@puzzle_input) == :foo
    end
  end
end
