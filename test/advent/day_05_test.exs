defmodule Advent.Day05Test do
  use Advent.Test.Case

  alias Advent.Day05

  @example_input """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  @puzzle_input File.read!("puzzle_inputs/day_05.txt")

  describe "part 1" do
    test "example" do
      assert Day05.part_1(@example_input) == 35
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day05.part_1(@puzzle_input) == 289_863_851
    end
  end

  describe "part 2" do
    @tag :skip
    test "example" do
      assert Day05.part_2(@example_input) == :foo
    end

    @tag :skip
    @tag :puzzle_input
    test "puzzle input" do
      assert Day05.part_2(@puzzle_input) == :foo
    end
  end
end
