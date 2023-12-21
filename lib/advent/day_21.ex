defmodule Advent.Day21 do
  @moduledoc """
  Day 21
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input, steps \\ 64) do
    {map, start} = input |> parse()

    rem_2 = rem(steps, 2)

    [start]
    |> walk([], 0, %{}, map, steps)
    |> Map.values()
    |> Enum.count(&(rem(&1, 2) == rem_2))
  end

  defp walk(_, _, distance, visited, _, steps) when distance > steps, do: visited
  defp walk([], [], _distance, visited, _map, _steps), do: visited

  defp walk([coord | coords], next_coords, distance, visited, map, steps) do
    visited = Map.put(visited, coord, distance)

    next_coords =
      coord
      |> neighbours(map, visited)
      |> Enum.reduce(next_coords, &[&1 | &2])

    walk(coords, next_coords, distance, visited, map, steps)
  end

  defp walk([], next_coords, distance, visited, map, steps) do
    walk(Enum.uniq(next_coords), [], distance + 1, visited, map, steps)
  end

  defp neighbours({x, y}, map, vistied) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.filter(fn coord -> MapSet.member?(map, coord) and not Map.has_key?(vistied, coord) end)
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
    map =
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {char, x} ->
          case char do
            "." -> {{x, y}, :open}
            "#" -> {{x, y}, :wall}
            "S" -> {{x, y}, :start}
          end
        end)
      end)
      |> Enum.into(%{})

    open =
      map
      |> Enum.filter(fn {_, type} -> type == :open end)
      |> Enum.map(fn {coord, _} -> coord end)
      |> MapSet.new()

    [start] =
      map
      |> Enum.filter(fn {_, type} -> type == :start end)
      |> Enum.map(fn {coord, _} -> coord end)

    {open, start}
  end
end
