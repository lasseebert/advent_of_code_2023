defmodule Advent.Day17Test do
  use Advent.Test.Case

  alias Advent.Day17

  @example_input_1 """
  2413432311323
  3215453535623
  3255245654254
  3446585845452
  4546657867536
  1438598798454
  4457876987766
  3637877979653
  4654967986887
  4564679986453
  1224686865563
  2546548887735
  4322674655533
  """

  @example_input_2 """
  111111111111
  999999999991
  999999999991
  999999999991
  999999999991
  """

  @puzzle_input File.read!("puzzle_inputs/day_17.txt")

  describe "part 1" do
    test "example" do
      assert Day17.part_1(@example_input_1) == 102
    end

    @tag timeout: :infinity
    @tag :puzzle_input
    test "puzzle input" do
      assert Day17.part_1(@puzzle_input) == 907
    end
  end

  describe "part 2" do
    test "example_1" do
      assert Day17.part_2(@example_input_1) == 94
    end

    test "example_2" do
      assert Day17.part_2(@example_input_2) == 71
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day17.part_2(@puzzle_input) == 1057
    end
  end
end
