defmodule Advent.Day07Test do
  use Advent.Test.Case

  alias Advent.Day07

  @example_input """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  @puzzle_input File.read!("puzzle_inputs/day_07.txt")

  describe "part 1" do
    test "example" do
      assert Day07.part_1(@example_input) == 6440
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day07.part_1(@puzzle_input) == 248_113_761
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day07.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day07.part_2(@puzzle_input) == :foo
    end
  end
end
