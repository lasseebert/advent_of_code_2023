defmodule Advent.Day15Test do
  use Advent.Test.Case

  alias Advent.Day15

  @example_input """
  rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
  """

  @puzzle_input File.read!("puzzle_inputs/day_15.txt")

  describe "part 1" do
    test "example" do
      assert Day15.part_1(@example_input) == 1320
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day15.part_1(@puzzle_input) == 509_784
    end
  end

  describe "part 2" do
    test "example" do
      assert Day15.part_2(@example_input) == 145
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day15.part_2(@puzzle_input) == 230_197
    end
  end
end
