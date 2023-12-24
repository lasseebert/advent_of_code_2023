defmodule Advent.Day24 do
  @moduledoc """
  Day 24
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t(), {integer, integer}) :: integer
  def part_1(input, test_area \\ {200_000_000_000_000, 400_000_000_000_000}) do
    input
    |> parse()
    |> find_test_area_intersections(test_area)
  end

  defp find_test_area_intersections(hails, test_area) do
    hails =
      hails
      |> Enum.map(fn {{px, py, _pz}, {vx, vy, _vz}} -> {{px, py}, {vx, vy}} end)
      |> Enum.map(fn {pos, vel} -> {pos, add(pos, vel)} end)

    for(h1 <- hails, h2 <- hails, h1 < h2, do: {h1, h2})
    |> Enum.count(fn {hail_1, hail_2} -> intersect_in_test_area?(hail_1, hail_2, test_area) end)
  end

  # https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_points_on_each_line_segment
  #
  # t/factor is the time of intersection for hail 1
  # u/factor is the time of intersection for hail 2
  defp intersect_in_test_area?({{x1, y1}, {x2, y2}}, {{x3, y3}, {x4, y4}}, {min, max}) do
    factor = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

    if factor == 0 do
      false
    else
      t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / factor
      u = ((x1 - x3) * (y1 - y2) - (y1 - y3) * (x1 - x2)) / factor

      x = x1 + t * (x2 - x1)
      y = y1 + t * (y2 - y1)

      t >= 0 and u >= 0 and x >= min and x <= max and y >= min and y <= max
    end
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()

    0
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_hail/1)
  end

  defp parse_hail(line) do
    line
    |> String.split("@", trim: true)
    |> Enum.map(&parse_coord/1)
    |> then(fn [pos, vel] -> {pos, vel} end)
  end

  defp parse_coord(coord) do
    coord
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [x, y, z] -> {x, y, z} end)
  end
end
