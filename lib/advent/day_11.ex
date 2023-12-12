defmodule Advent.Day11 do
  @moduledoc """
  Day 11
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    map = input |> parse()

    empty_columns = find_empty_columns(map)
    empty_rows = find_empty_rows(map)

    for(a <- map, b <- map, a < b, do: {a, b})
    |> Enum.map(fn {a, b} -> distance(a, b, empty_columns, empty_rows) end)
    |> Enum.sum()
  end

  defp distance({x1, y1}, {x2, y2}, empty_columns, empty_rows) do
    abs(x1 - x2) + abs(y1 - y2) +
      Enum.count(x1..x2, &MapSet.member?(empty_columns, &1)) +
      Enum.count(y1..y2, &MapSet.member?(empty_rows, &1))
  end

  defp find_empty_columns(map) do
    filled_columns =
      Enum.reduce(map, MapSet.new(), fn {x, _y}, filled_columns ->
        MapSet.put(filled_columns, x)
      end)

    all_columns = MapSet.new(0..Enum.max(filled_columns))

    MapSet.difference(all_columns, filled_columns)
  end

  defp find_empty_rows(map) do
    filled_rows =
      Enum.reduce(map, MapSet.new(), fn {_x, y}, filled_rows ->
        MapSet.put(filled_rows, y)
      end)

    all_rows = MapSet.new(0..Enum.max(filled_rows))

    MapSet.difference(all_rows, filled_rows)
  end

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
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn {line, y}, map ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {char, x}, map ->
        case char do
          "#" -> MapSet.put(map, {x, y})
          "." -> map
        end
      end)
    end)
  end
end
