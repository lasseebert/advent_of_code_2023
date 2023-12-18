defmodule Advent.Day18 do
  @moduledoc """
  Day 18
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&elem(&1, 0))
    |> find_coords()
    |> find_area()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.map(&elem(&1, 1))
    |> find_coords()
    |> find_area()
  end

  defp find_area(coords) do
    n = length(coords)

    edges =
      coords
      |> Stream.cycle()
      |> Stream.chunk_every(2, 1, :discard)
      |> Stream.map(fn [c1, c2] -> {dir(c1, c2), {c1, c2}} end)
      |> Enum.take(n)

    corners =
      edges
      |> Stream.cycle()
      |> Stream.chunk_every(3, 1, :discard)
      |> Enum.take(n)

    corners
    # This finds the outside path of the polygon
    |> Enum.map(fn [{dir_before, _}, {dir, {{x1, y1}, {x2, y2}}}, {dir_after, _}] ->
      case {dir_before, dir, dir_after} do
        {:left, :up, :left} -> {x1, y1, x2, y2}
        {:left, :up, :right} -> {x1, y1, x2, y2 + 1}
        {:right, :up, :left} -> {x1, y1 + 1, x2, y2}
        {:right, :up, :right} -> {x1, y1 + 1, x2, y2 + 1}
        {:left, :down, :left} -> {x1 + 1, y1, x2 + 1, y2}
        {:left, :down, :right} -> {x1 + 1, y1, x2 + 1, y2 + 1}
        {:right, :down, :left} -> {x1 + 1, y1 + 1, x2 + 1, y2}
        {:right, :down, :right} -> {x1 + 1, y1 + 1, x2 + 1, y2 + 1}
        {:up, :left, :up} -> {x1, y1, x2, y2}
        {:up, :left, :down} -> {x1, y1, x2 + 1, y2}
        {:down, :left, :up} -> {x1 + 1, y1, x2, y2}
        {:down, :left, :down} -> {x1 + 1, y1, x2 + 1, y2}
        {:up, :right, :up} -> {x1, y1 + 1, x2, y2 + 1}
        {:up, :right, :down} -> {x1, y1 + 1, x2 + 1, y2 + 1}
        {:down, :right, :up} -> {x1 + 1, y1 + 1, x2, y2 + 1}
        {:down, :right, :down} -> {x1 + 1, y1 + 1, x2 + 1, y2 + 1}
      end
    end)
    # Use the shoelace formula to find the area of the polygon
    |> Enum.map(fn {x1, y1, x2, y2} -> x1 * y2 - x2 * y1 end)
    |> Enum.sum()
    |> abs()
    |> div(2)
  end

  defp dir({x1, y1}, {x2, y2}) do
    cond do
      x1 == x2 and y1 < y2 -> :up
      x1 == x2 and y1 > y2 -> :down
      x1 < x2 and y1 == y2 -> :right
      x1 > x2 and y1 == y2 -> :left
    end
  end

  defp find_coords(instructions) do
    {edges, {0, 0}} =
      instructions
      |> Enum.map_reduce({0, 0}, fn {dir, steps}, coord ->
        new_coord = move(coord, dir, steps)
        {new_coord, new_coord}
      end)

    edges
  end

  defp move({x, y}, :up, steps), do: {x, y + steps}
  defp move({x, y}, :down, steps), do: {x, y - steps}
  defp move({x, y}, :left, steps), do: {x - steps, y}
  defp move({x, y}, :right, steps), do: {x + steps, y}

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    ~r/^([UDRL]) (\d+) \(#([0-9a-f]{5})([0-3])\)$/
    |> Regex.run(line, capture: :all_but_first)
    |> then(fn [dir, steps, hex_steps, hex_dir] ->
      dir =
        case dir do
          "U" -> :up
          "D" -> :down
          "L" -> :left
          "R" -> :right
        end

      hex_dir =
        case hex_dir do
          "0" -> :right
          "1" -> :down
          "2" -> :left
          "3" -> :up
        end

      steps = String.to_integer(steps)
      hex_steps = String.to_integer(hex_steps, 16)

      {{dir, steps}, {hex_dir, hex_steps}}
    end)
  end
end
