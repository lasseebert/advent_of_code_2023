defmodule Advent.Day25Test do
  use Advent.Test.Case

  alias Advent.Day25

  @example_input """
  jqt: rhn xhk nvd
  rsh: frs pzl lsr
  xhk: hfx
  cmg: qnr nvd lhk bvb
  rhn: xhk bvb hfx
  bvb: xhk hfx
  pzl: lsr hfx nvd
  qnr: nvd
  ntq: jqt hfx bvb xhk
  nvd: lhk
  lsr: lhk
  rzs: qnr cmg lsr rsh
  frs: qnr lhk lsr
  """

  @puzzle_input File.read!("puzzle_inputs/day_25.txt")

  describe "part 1" do
    test "example" do
      assert Day25.part_1(@example_input) == 54
    end

    @tag timeout: :infinity
    @tag :puzzle_input
    test "puzzle input" do
      assert Day25.part_1(@puzzle_input) == 562_912
    end
  end
end
