defmodule Advent.Day01Test do
  use Advent.Test.Case

  alias Advent.Day01

  @example_input_part_1 """
  1abc2
  pqr3stu8vwx
  a1b2c3d4e5f
  treb7uchet
  """

  @example_input_part_2 """
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
  """

  @puzzle_input File.read!("puzzle_inputs/day_01.txt")

  describe "part 1" do
    test "example" do
      assert Day01.part_1(@example_input_part_1) == 142
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day01.part_1(@puzzle_input) == 55_090
    end
  end

  describe "part 2" do
    test "example" do
      assert Day01.part_2(@example_input_part_2) == 281
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day01.part_2(@puzzle_input) == 54_845
    end
  end
end
