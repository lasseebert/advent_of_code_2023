defmodule Advent.Day19Test do
  use Advent.Test.Case

  alias Advent.Day19

  @example_input """
  px{a<2006:qkq,m>2090:A,rfg}
  pv{a>1716:R,A}
  lnx{m>1548:A,A}
  rfg{s<537:gd,x>2440:R,A}
  qs{s>3448:A,lnx}
  qkq{x<1416:A,crn}
  crn{x>2662:A,R}
  in{s<1351:px,qqz}
  qqz{s>2770:qs,m<1801:hdj,R}
  gd{a>3333:R,R}
  hdj{m>838:A,pv}

  {x=787,m=2655,a=1222,s=2876}
  {x=1679,m=44,a=2067,s=496}
  {x=2036,m=264,a=79,s=2244}
  {x=2461,m=1339,a=466,s=291}
  {x=2127,m=1623,a=2188,s=1013}
  """

  @puzzle_input File.read!("puzzle_inputs/day_19.txt")

  describe "part 1" do
    test "example" do
      assert Day19.part_1(@example_input) == 19_114
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day19.part_1(@puzzle_input) == 391_132
    end
  end

  describe "part 2" do
    test "example" do
      assert Day19.part_2(@example_input) == 167_409_079_868_000
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day19.part_2(@puzzle_input) == 128_163_929_109_524
    end
  end
end
