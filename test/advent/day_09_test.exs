defmodule Advent.Day09Test do
  use Advent.Test.Case

  alias Advent.Day09

  @example_input """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  @puzzle_input File.read!("puzzle_inputs/day_09.txt")

  describe "part 1" do
    test "example" do
      assert Day09.part_1(@example_input) == 114
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day09.part_1(@puzzle_input) == 1_842_168_671
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day09.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day09.part_2(@puzzle_input) == :foo
    end
  end
end
