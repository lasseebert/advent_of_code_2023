defmodule Advent.Day10 do
  @moduledoc """
  Day 10
  """

  @type coord :: {integer, integer}

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    # The distance to the furthest point in the loop is the loop size divided by 2.
    # The loop size will always be even.
    input |> parse() |> shrink() |> Enum.count() |> div(2)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    loop = parse(input)
    box = bounding_box(loop)

    point_outside_loop = box |> Enum.min()

    tiles_outside = walk_outside(loop, box, point_outside_loop, MapSet.new([point_outside_loop]))

    # Shrink all maps to the original size.
    loop = shrink(loop)
    box = shrink(box)
    tiles_outside = shrink(tiles_outside)

    box
    |> MapSet.difference(tiles_outside)
    |> MapSet.difference(loop)
    |> Enum.count()
  end

  defp shrink(map) do
    # Only keep the middle tiles
    map
    |> Enum.reduce(MapSet.new(), fn {x, y}, shrinked_map ->
      if rem(x, 3) == 1 and rem(y, 3) == 1 do
        MapSet.put(shrinked_map, {x, y})
      else
        shrinked_map
      end
    end)
  end

  defp walk_outside(loop, box, pos, seen) do
    pos
    |> neighbours()
    |> Enum.reduce(seen, fn next_pos, seen ->
      if MapSet.member?(seen, next_pos) or MapSet.member?(loop, next_pos) or not MapSet.member?(box, next_pos) do
        seen
      else
        seen = MapSet.put(seen, next_pos)
        walk_outside(loop, box, next_pos, seen)
      end
    end)
  end

  defp neighbours({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
  end

  defp bounding_box(loop) do
    {min_x, max_x} = loop |> Enum.map(fn {x, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = loop |> Enum.map(fn {_, y} -> y end) |> Enum.min_max()

    for(y <- (min_y - 1)..(max_y + 1), x <- (min_x - 1)..(max_x + 1), do: {x, y})
    |> MapSet.new()
  end

  # Parses the map as a map that is three times the size of the input.
  # This is to do two thing:
  #
  # * We don't need every cell to know about direction of the pipe
  # * We can more easily find the inside and the outside of the loop
  #
  # E.g. an L pipe in the input will be parsed as:
  #
  #   .#.
  #   .##
  #   ...
  #
  @spec parse(String.t()) :: MapSet.t()
  defp parse(input) do
    tiles = read_tiles(input)

    map = expand_map(tiles)

    start_pos =
      tiles
      |> Enum.find(fn {_coord, tile} -> tile == "S" end)
      |> elem(0)
      |> then(fn {x, y} -> {x * 3 + 1, y * 3 + 1} end)

    map
    |> find_loop(start_pos, MapSet.new([start_pos]))
    |> remove_extra_start_pos_tiles(start_pos)
  end

  defp remove_extra_start_pos_tiles(map, start_pos) do
    start_pos
    |> neighbours()
    |> Enum.reduce(map, fn pos, map ->
      pos
      |> neighbours()
      |> Enum.count(fn neighbour -> MapSet.member?(map, neighbour) end)
      |> case do
        1 -> MapSet.delete(map, pos)
        2 -> map
      end
    end)
  end

  defp find_loop(map, pos, seen) do
    pos
    |> neighbours()
    |> Enum.reduce(seen, fn next_pos, seen ->
      if !MapSet.member?(map, next_pos) || MapSet.member?(seen, next_pos) do
        seen
      else
        seen = MapSet.put(seen, next_pos)
        find_loop(map, next_pos, seen)
      end
    end)
  end

  defp expand_map(tiles) do
    # | is a vertical pipe connecting north and south.
    # - is a horizontal pipe connecting east and west.
    # L is a 90-degree bend connecting north and east.
    # J is a 90-degree bend connecting north and west.
    # 7 is a 90-degree bend connecting south and west.
    # F is a 90-degree bend connecting south and east.
    # . is ground; there is no pipe in this tile.
    # S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
    tiles
    |> Enum.reduce(MapSet.new(), fn {{x, y}, char}, map ->
      x1 = x * 3
      y1 = y * 3

      north = {x1 + 1, y1}
      east = {x1 + 2, y1 + 1}
      south = {x1 + 1, y1 + 2}
      west = {x1, y1 + 1}
      center = {x1 + 1, y1 + 1}

      case char do
        "|" -> [north, south]
        "-" -> [west, east]
        "L" -> [north, east]
        "J" -> [north, west]
        "7" -> [south, west]
        "F" -> [south, east]
        "." -> []
        "S" -> [north, east, south, west]
      end
      |> Enum.reduce(map, fn coord, map -> MapSet.put(map, coord) end)
      |> MapSet.put(center)
    end)
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
        {{x, y}, char}
      end)
    end)
    |> Enum.into(%{})
  end
end
