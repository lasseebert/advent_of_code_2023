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
    test "example 1" do
      assert Day21.part_2(@example_input, 6) == 16
    end

    test "example 2" do
      assert Day21.part_2(@example_input, 10) == 50
    end

    test "example 3" do
      assert Day21.part_2(@example_input, 50) == 1594
    end

    test "example 4" do
      assert Day21.part_2(@example_input, 100) == 6536
    end

    test "example 5" do
      assert Day21.part_2(@example_input, 500) == 167_004
    end

    test "example 6" do
      assert Day21.part_2(@example_input, 1000) == 668_697
    end

    test "example 7" do
      assert Day21.part_2(@example_input, 5000) == 16_733_044
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day21.part_2(@puzzle_input) == 602_259_568_764_234
    end
  end
end
