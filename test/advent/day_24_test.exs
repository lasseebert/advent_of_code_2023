defmodule Advent.Day24Test do
  use Advent.Test.Case

  alias Advent.Day24

  @example_input """
  19, 13, 30 @ -2,  1, -2
  18, 19, 22 @ -1, -1, -2
  20, 25, 34 @ -2, -2, -4
  12, 31, 28 @ -1, -2, -1
  20, 19, 15 @  1, -5, -3
  """

  @puzzle_input File.read!("puzzle_inputs/day_24.txt")

  describe "part 1" do
    test "example" do
      assert Day24.part_1(@example_input, {7, 27}) == 2
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day24.part_1(@puzzle_input) == 28_174
    end
  end

  describe "part 2" do
    test "example" do
      assert Day24.part_2(@example_input) == 47
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day24.part_2(@puzzle_input) == 568_386_357_876_600
    end
  end
end
