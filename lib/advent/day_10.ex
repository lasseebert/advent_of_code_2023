defmodule Advent.Day10 do
  @moduledoc """
  Day 10
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    # The distance to the furthest point in the loop is the loop size divided by 2.
    # The loop size will always be even.
    input |> parse() |> Enum.count |> div(2)
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

  # Returns a MapSet of the loop
  @spec parse(String.t()) :: MapSet.t()
  defp parse(input) do
    input
    |> read_tiles()
    |> parse_map()
    |> then(fn {map, start_pos} -> find_loop(map, start_pos, MapSet.new([start_pos])) end)
  end

  defp read_tiles(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        {{x, y}, parse_char(char)}
      end)
    end)
    |> Enum.into(%{})
  end

  defp parse_char(char) do
    %{
      north: north?(char),
      east: east?(char),
      south: south?(char),
      west: west?(char)
    }
  end

  # | is a vertical pipe connecting north and south.
  # - is a horizontal pipe connecting east and west.
  # L is a 90-degree bend connecting north and east.
  # J is a 90-degree bend connecting north and west.
  # 7 is a 90-degree bend connecting south and west.
  # F is a 90-degree bend connecting south and east.
  # . is ground; there is no pipe in this tile.
  # S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

  defp north?("S"), do: true
  defp north?("|"), do: true
  defp north?("L"), do: true
  defp north?("J"), do: true
  defp north?(_), do: false

  defp east?("S"), do: true
  defp east?("-"), do: true
  defp east?("L"), do: true
  defp east?("F"), do: true
  defp east?(_), do: false

  defp south?("S"), do: true
  defp south?("|"), do: true
  defp south?("7"), do: true
  defp south?("F"), do: true
  defp south?(_), do: false

  defp west?("S"), do: true
  defp west?("-"), do: true
  defp west?("J"), do: true
  defp west?("7"), do: true
  defp west?(_), do: false

  defp find_loop(map, pos, seen) do
    map
    |> Map.fetch!(pos)
    |> Enum.reduce(seen, fn next_pos, seen ->
      if MapSet.member?(seen, next_pos) do
        seen
      else
        seen = MapSet.put(seen, next_pos)
        find_loop(map, next_pos, seen)
      end
    end)
  end

  defp parse_map(tiles) do
    max_x = tiles |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    max_y = tiles |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    start_pos = tiles |> Enum.find(fn {_coord, tile} -> tile |> Map.values() |> Enum.uniq() == [true] end) |> elem(0)

    map =
      %{}
      |> add_vertical_connections(tiles, max_x, max_y)
      |> add_horizontal_connections(tiles, max_x, max_y)

    {map, start_pos}
  end

  defp add_vertical_connections(map, tiles, max_x, max_y) do
    0..max_y
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(map, fn [y1, y2], map ->
      0..max_x
      |> Enum.reduce(map, fn x, map ->
        if Map.fetch!(tiles, {x, y1}).south and Map.fetch!(tiles, {x, y2}).north do
          map
          |> Map.update({x, y1}, [{x, y2}], &[{x, y2} | &1])
          |> Map.update({x, y2}, [{x, y1}], &[{x, y1} | &1])
        else
          map
        end
      end)
    end)
  end

  def add_horizontal_connections(map, tiles, max_x, max_y) do
    0..max_x
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(map, fn [x1, x2], map ->
      0..max_y
      |> Enum.reduce(map, fn y, map ->
        if Map.fetch!(tiles, {x1, y}).east and Map.fetch!(tiles, {x2, y}).west do
          map
          |> Map.update({x1, y}, [{x2, y}], &[{x2, y} | &1])
          |> Map.update({x2, y}, [{x1, y}], &[{x1, y} | &1])
        else
          map
        end
      end)
    end)
  end

end
