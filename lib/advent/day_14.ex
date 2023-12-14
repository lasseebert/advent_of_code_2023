defmodule Advent.Day14 do
  @moduledoc """
  Day 14
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {{_width, height} = map_size, walls, boulders} = input |> parse()

    boulders = tilt(boulders, :north, walls, map_size)

    boulders
    |> Enum.map(&calc_load(&1, height))
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {{_width, height} = map_size, walls, boulders} = input |> parse()

    boulders
    |> Stream.unfold(fn boulders ->
      next_boulders =
        boulders
        |> tilt(:north, walls, map_size)
        |> tilt(:west, walls, map_size)
        |> tilt(:south, walls, map_size)
        |> tilt(:east, walls, map_size)

      {boulders, next_boulders}
    end)
    |> iterate(1_000_000_000)
    |> Enum.map(&calc_load(&1, height))
    |> Enum.sum()
  end

  defp iterate(stream, count) do
    stream
    |> Stream.with_index()
    |> Enum.reduce_while({%{}, %{}}, fn {boulders, index}, {seen_indexes, seen_boulders} ->
      if Map.has_key?(seen_boulders, boulders) do
        # The boulders at index zero is the initial boulders state, so we are
        # looking for the boulders at index count.
        first_index = Map.fetch!(seen_boulders, boulders)
        cycle_length = index - first_index
        missing_count = rem(count - index, cycle_length)
        boulders_at_count = Map.fetch!(seen_indexes, first_index + missing_count)

        {:halt, boulders_at_count}
      else
        seen_indexes = Map.put(seen_indexes, index, boulders)
        seen_boulders = Map.put(seen_boulders, boulders, index)
        {:cont, {seen_indexes, seen_boulders}}
      end
    end)
  end

  defp tilt(boulders, dir, walls, map_size) do
    boulders
    |> Enum.sort_by(fn {x, y} ->
      case dir do
        :north -> y
        :east -> -x
        :south -> -y
        :west -> x
      end
    end)
    |> Enum.reduce(boulders, fn coord, boulders ->
      move(boulders, dir, coord, walls, map_size)
    end)
  end

  defp move(boulders, dir, coord, walls, map_size) do
    next_coord = move_single(coord, dir)

    if MapSet.member?(walls, next_coord) or MapSet.member?(boulders, next_coord) or outside?(next_coord, map_size) do
      boulders
    else
      boulders
      |> MapSet.delete(coord)
      |> MapSet.put(next_coord)
      |> move(dir, next_coord, walls, map_size)
    end
  end

  defp outside?({x, y}, {width, height}) do
    x < 0 or x >= width or y < 0 or y >= height
  end

  defp move_single({x, y}, :north), do: {x, y - 1}
  defp move_single({x, y}, :east), do: {x + 1, y}
  defp move_single({x, y}, :south), do: {x, y + 1}
  defp move_single({x, y}, :west), do: {x - 1, y}

  defp calc_load({_x, y}, height) do
    height - y
  end

  defp parse(input) do
    tiles = parse_tiles(input)

    map_size =
      tiles
      |> Map.keys()
      |> Enum.max()
      |> then(fn {x, y} -> {x + 1, y + 1} end)

    walls =
      tiles
      |> Enum.filter(fn {_, tile} -> tile == :wall end)
      |> Enum.map(fn {coord, _} -> coord end)
      |> MapSet.new()

    boulders =
      tiles
      |> Enum.filter(fn {_, tile} -> tile == :boulder end)
      |> Enum.map(fn {coord, _} -> coord end)
      |> MapSet.new()

    {map_size, walls, boulders}
  end

  defp parse_tiles(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        tile =
          case char do
            "O" -> :boulder
            "#" -> :wall
            "." -> :floor
          end

        {{x, y}, tile}
      end)
    end)
    |> Enum.into(%{})
  end
end
