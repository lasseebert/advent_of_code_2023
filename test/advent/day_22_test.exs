defmodule Advent.Day22Test do
  use Advent.Test.Case

  alias Advent.Day22

  @example_input """
  1,0,1~1,2,1
  0,0,2~2,0,2
  0,2,3~2,2,3
  0,0,4~0,2,4
  2,0,5~2,2,5
  0,1,6~2,1,6
  1,1,8~1,1,9
  """

  @puzzle_input File.read!("puzzle_inputs/day_22.txt")

  describe "part 1" do
    test "example" do
      assert Day22.part_1(@example_input) == 5
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day22.part_1(@puzzle_input) == 507
    end
  end

  describe "part 2" do
    test "example" do
      assert Day22.part_2(@example_input) == 7
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day22.part_2(@puzzle_input) == 51_733
    end
  end
end
