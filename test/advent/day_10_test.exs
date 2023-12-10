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

  @example_input_3 """
  ...........
  .S-------7.
  .|F-----7|.
  .||.....||.
  .||.....||.
  .|L-7.F-J|.
  .|..|.|..|.
  .L--J.L--J.
  ...........
  """

  @example_input_4 """
  .F----7F7F7F7F-7....
  .|F--7||||||||FJ....
  .||.FJ||||||||L7....
  FJL7L7LJLJ||LJ.L-7..
  L--J.L7...LJS7F-7L7.
  ....F-J..F7FJ|L7L7L7
  ....L7.F7||L7|.L7L7|
  .....|FJLJ|FJ|F7|.LJ
  ....FJL-7.||.||||...
  ....L---J.LJ.LJLJ...
  """

  @example_input_5 """
  FF7FSF7F7F7F7F7F---7
  L|LJ||||||||||||F--J
  FL-7LJLJ||||||LJL-77
  F--JF--7||LJLJ7F7FJ-
  L---JF-JLJ.||-FJLJJ7
  |F|F-JF---7F7-L7L|7|
  |FFJF7L7F-JF7|JL---7
  7-L-JL7||F7|L7F-7F7|
  L.L7LFJ|||||FJL7||LJ
  L7JLJL-JLJLJL--JLJ.L
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
    test "example 3" do
      assert Day10.part_2(@example_input_3) == 4
    end

    test "example 4" do
      assert Day10.part_2(@example_input_4) == 8
    end

    test "example 5" do
      assert Day10.part_2(@example_input_5) == 10
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day10.part_2(@puzzle_input) == 407
    end
  end
end
