defmodule Advent.Day08Test do
  use Advent.Test.Case

  alias Advent.Day08

  @example_input_1 """
  RL

  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)
  """

  @example_input_2 """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  @example_input_3 """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
  """

  @puzzle_input File.read!("puzzle_inputs/day_08.txt")

  describe "part 1" do
    test "example 1" do
      assert Day08.part_1(@example_input_1) == 2
    end

    test "example 2" do
      assert Day08.part_1(@example_input_2) == 6
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day08.part_1(@puzzle_input) == 21_883
    end
  end

  describe "part 2" do
    test "example" do
      assert Day08.part_2(@example_input_3) == 6
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day08.part_2(@puzzle_input) == 12_833_235_391_111
    end
  end
end
