defmodule Advent.Day22 do
  @moduledoc """
  Day 22
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    bricks =
      input
      |> parse()
      |> Enum.sort_by(fn {{_x, _y, z}, _} -> z end)
      |> Enum.with_index()
      |> drop_bricks([])

    Enum.count(bricks, fn brick ->
      new_bricks = List.delete(bricks, brick)
      new_bricks_dropped = drop_bricks(new_bricks, [])
      new_bricks == new_bricks_dropped
    end)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    # This whole thing has a bad complexity, but it works.
    # Running time is 3-4 seconds for each part.
    #
    # I think the complexity is O(n^3)
    bricks =
      input
      |> parse()
      |> Enum.sort_by(fn {{_x, _y, z}, _} -> z end)
      |> Enum.with_index()
      |> drop_bricks([])

    bricks
    |> Enum.map(fn brick ->
      new_bricks = List.delete(bricks, brick)
      new_bricks_dropped = drop_bricks(new_bricks, [])

      new_bricks
      |> MapSet.new()
      |> MapSet.intersection(MapSet.new(new_bricks_dropped))
      |> Enum.count()
      |> then(&(length(new_bricks) - &1))
    end)
    |> Enum.sum()
  end

  defp drop_bricks([], dropped), do: Enum.reverse(dropped)
  defp drop_bricks([{{{_, _, 1}, _}, _label} = brick | bricks], dropped), do: drop_bricks(bricks, [brick | dropped])

  defp drop_bricks([brick | bricks], dropped) do
    new_brick = brick |> move_down()

    if Enum.any?(dropped, &overlap?(&1, new_brick)) do
      drop_bricks(bricks, [brick | dropped])
    else
      drop_bricks([new_brick | bricks], dropped)
    end
  end

  defp move_down({{{x1, y1, z1}, {x2, y2, z2}}, label}) do
    {{{x1, y1, z1 - 1}, {x2, y2, z2 - 1}}, label}
  end

  defp overlap?({{{x1, y1, z1}, {x2, y2, z2}}, _}, {{{x3, y3, z3}, {x4, y4, z4}}, _}) do
    x_overlap = x1 <= x4 && x2 >= x3
    y_overlap = y1 <= y4 && y2 >= y3
    z_overlap = z1 <= z4 && z2 >= z3

    x_overlap && y_overlap && z_overlap
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_brick/1)
  end

  defp parse_brick(line) do
    line
    |> String.split("~", trim: true)
    |> Enum.map(&parse_coord/1)
    |> Enum.sort()
    |> List.to_tuple()
  end

  defp parse_coord(coord) do
    coord
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
