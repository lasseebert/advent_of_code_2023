defmodule Advent.Day03Test do
  use Advent.Test.Case

  alias Advent.Day03

  @example_input """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  @puzzle_input File.read!("puzzle_inputs/day_03.txt")

  describe "part 1" do
    test "example" do
      assert Day03.part_1(@example_input) == 4361
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day03.part_1(@puzzle_input) == 540_131
    end
  end

  describe "part 2" do
    test "example" do
      assert Day03.part_2(@example_input) == 467_835
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day03.part_2(@puzzle_input) == 86_879_020
    end
  end
end
