defmodule Advent.Day20Test do
  use Advent.Test.Case

  alias Advent.Day20

  @example_input_1 """
  broadcaster -> a, b, c
  %a -> b
  %b -> c
  %c -> inv
  &inv -> a
  """

  @example_input_2 """
  broadcaster -> a
  %a -> inv, con
  &inv -> b
  %b -> con
  &con -> output
  """

  @puzzle_input File.read!("puzzle_inputs/day_20.txt")

  describe "part 1" do
    test "example 1" do
      assert Day20.part_1(@example_input_1) == 32_000_000
    end

    test "example 2" do
      assert Day20.part_1(@example_input_2) == 11_687_500
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day20.part_1(@puzzle_input) == 938_065_580
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day20.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day20.part_2(@puzzle_input) == :foo
    end
  end
end
