defmodule Advent.Day14 do
  @moduledoc """
  Day 14
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {height, walls, boulders} = input |> parse()

    boulders = tilt_north(boulders, walls)

    boulders
    |> Enum.map(&calc_load(&1, height))
    |> Enum.sum()
  end

  defp tilt_north(boulders, walls) do
    boulders
    |> Enum.sort_by(fn {_, y} -> y end)
    |> Enum.reduce(boulders, fn coord, boulders ->
      move_north(boulders, coord, walls)
    end)
  end

  defp move_north(boulders, {_x, 0}, _walls), do: boulders

  defp move_north(boulders, {x, y}, walls) do
    next_coord = {x, y - 1}

    if MapSet.member?(walls, next_coord) or MapSet.member?(boulders, next_coord) do
      boulders
    else
      boulders
      |> MapSet.delete({x, y})
      |> MapSet.put(next_coord)
      |> move_north(next_coord, walls)
    end
  end

  defp calc_load({_x, y}, height) do
    height - y
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
    tiles = parse_tiles(input)

    height =
      tiles
      |> Map.keys()
      |> Enum.map(fn {_, y} -> y end)
      |> Enum.max()
      |> Kernel.+(1)

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

    {height, walls, boulders}
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
