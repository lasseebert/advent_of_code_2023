defmodule Advent.Day16Test do
  use Advent.Test.Case

  alias Advent.Day16

  @example_input ~S"""
  .|...\....
  |.-.\.....
  .....|-...
  ........|.
  ..........
  .........\
  ..../.\\..
  .-.-/..|..
  .|....-|.\
  ..//.|....
  """

  @puzzle_input File.read!("puzzle_inputs/day_16.txt")

  describe "part 1" do
    test "example" do
      assert Day16.part_1(@example_input) == 46
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day16.part_1(@puzzle_input) == 6795
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day16.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day16.part_2(@puzzle_input) == :foo
    end
  end
end
