defmodule Advent.Day10Test do
  use Advent.Test.Case

  alias Advent.Day10

  @example_input_1 """
  -L|F7
  7S-7|
  L|7||
  -L-J|
  L|-JF
  """

  @example_input_2 """
  7-F7-
  .FJ|7
  SJLL7
  |F--J
  LJ.LJ
  """

  @puzzle_input File.read!("puzzle_inputs/day_10.txt")

  describe "part 1" do
    test "example 1" do
      assert Day10.part_1(@example_input_1) == 4
    end

    test "example 2" do
      assert Day10.part_1(@example_input_2) == 8
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day10.part_1(@puzzle_input) == 7093
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day10.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day10.part_2(@puzzle_input) == :foo
    end
  end
end
