defmodule Advent.Day12Test do
  use Advent.Test.Case

  alias Advent.Day12

  @example_input """
  ???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1
  """

  @small_example_input """
  ?###???????? 3,2,1
  """

  @puzzle_input File.read!("puzzle_inputs/day_12.txt")

  describe "part 1" do
    test "example" do
      assert Day12.part_1(@example_input) == 21
    end

    test "mini example" do
      assert Day12.part_1(@small_example_input) == 10
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day12.part_1(@puzzle_input) == 7653
    end
  end

  describe "part 2" do
    test "example" do
      assert Day12.part_2(@example_input) == 525_152
    end

    test "mini example" do
      assert Day12.part_2(@small_example_input) == 506_250
    end

    @tag :puzzle_input
    test "puzzle input" do
      assert Day12.part_2(@puzzle_input) == 60_681_419_004_564
    end
  end
end
