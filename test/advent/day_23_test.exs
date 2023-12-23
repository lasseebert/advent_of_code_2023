defmodule Advent.Day23Test do
  use Advent.Test.Case

  alias Advent.Day23

  @example_input """
  #.#####################
  #.......#########...###
  #######.#########.#.###
  ###.....#.>.>.###.#.###
  ###v#####.#v#.###.#.###
  ###.>...#.#.#.....#...#
  ###v###.#.#.#########.#
  ###...#.#.#.......#...#
  #####.#.#.#######.#.###
  #.....#.#.#.......#...#
  #.#####.#.#.#########v#
  #.#...#...#...###...>.#
  #.#.#v#######v###.###v#
  #...#.>.#...>.>.#.###.#
  #####v#.#.###v#.#.###.#
  #.....#...#...#.#.#...#
  #.#########.###.#.#.###
  #...###...#...#...#.###
  ###.###.#.###v#####v###
  #...#...#.#.>.>.#.>.###
  #.###.###.#.###.#.#v###
  #.....###...###...#...#
  #####################.#
  """

  @puzzle_input File.read!("puzzle_inputs/day_23.txt")

  describe "part 1" do
    test "example" do
      assert Day23.part_1(@example_input) == 94
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day23.part_1(@puzzle_input) == 2330
    end
  end

  describe "part 2" do
    test "example" do
      assert Day23.part_2(@example_input) == 154
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day23.part_2(@puzzle_input) == 6518
    end
  end
end
