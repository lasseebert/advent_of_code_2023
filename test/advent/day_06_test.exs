defmodule Advent.Day06Test do
  use Advent.Test.Case

  alias Advent.Day06

  @example_input """
  Time:      7  15   30
  Distance:  9  40  200
  """

  @puzzle_input File.read!("puzzle_inputs/day_06.txt")

  describe "part 1" do
    test "example" do
      assert Day06.part_1(@example_input) == 288
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day06.part_1(@puzzle_input) == 1_710_720
    end
  end

  describe "part 2" do
    test "example" do
      assert Day06.part_2(@example_input) == 71_503
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day06.part_2(@puzzle_input) == 35_349_468
    end
  end
end
