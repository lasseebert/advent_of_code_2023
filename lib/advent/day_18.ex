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
    |> find_edges()
    |> find_area()
    |> Enum.count()
  end

  defp find_area(edges) do
    all_coords = edges |> Enum.flat_map(fn {c1, c2} -> [c1, c2] end) |> Enum.uniq()

    {min_x, max_x} = all_coords |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = all_coords |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    vertical_edges =
      edges
      |> Enum.filter(fn {{x1, _y1}, {x2, _y2}} -> x1 == x2 end)

    # Add all edges to the map
    map =
      edges
      |> Enum.reduce(MapSet.new(), fn {c1, c2}, map ->
        [{x1, y1}, {x2, y2}] = Enum.sort([c1, c2])

        for(x <- x1..x2, y <- y1..y2, do: {x, y})
        |> Enum.reduce(map, &MapSet.put(&2, &1))
      end)

    # Add the inner area using the scan line algorith
    Enum.reduce(min_y..max_y, map, fn y, map ->
      scan_line(map, y, min_x, max_x, vertical_edges)
    end)
  end

  defp scan_line(map, y, min_x, max_x, edges) do
    min_x..max_x
    |> Enum.reduce({map, 0}, fn x, {map, parity} ->
      coord = {x, y}

      parity =
        edges
        |> Enum.filter(fn {{x1, y1}, {x1, y2}} -> x1 == x and ((y1 <= y and y <= y2) or (y2 <= y and y <= y1)) end)
        |> case do
          [] ->
            # No edge intersection
            parity

          [{{^x, y1}, {^x, y2}}] ->
            cond do
              # Edge intersects in min value. This is ignored, because we need
              # to either ignore the min or max value of each edge, otherwise
              # it would not work when we hit a horizontal edge.
              #
              # E.g.
              #
              #     #
              #     #
              #     ####
              #        #
              #        #
              #
              # Here we only want one hit, and:
              #
              #     #   #
              #     #   #
              #     #####
              #
              # Here we want 0 or 2 hits
              Enum.min([y1, y2]) == y -> parity
              y1 > y2 -> parity + 1
              y1 < y2 -> parity - 1
            end
        end

      map =
        if parity != 0 do
          # When parity is non-zero we are inside the polygon
          MapSet.put(map, coord)
        else
          map
        end

      {map, parity}
    end)
    |> then(fn {map, 0} -> map end)
  end

  defp find_edges(instructions) do
    {edges, {0, 0}} =
      instructions
      |> Enum.map_reduce({0, 0}, fn {dir, steps, _color}, coord ->
        new_coord = move(coord, dir, steps)
        {{coord, new_coord}, new_coord}
      end)

    edges
  end

  defp move({x, y}, :up, steps), do: {x, y + steps}
  defp move({x, y}, :down, steps), do: {x, y - steps}
  defp move({x, y}, :left, steps), do: {x - steps, y}
  defp move({x, y}, :right, steps), do: {x + steps, y}

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
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    ~r/^([UDRL]) (\d+) \((#[0-9a-f]{6})\)$/
    |> Regex.run(line, capture: :all_but_first)
    |> then(fn [dir, steps, color] ->
      dir =
        case dir do
          "U" -> :up
          "D" -> :down
          "L" -> :left
          "R" -> :right
        end

      steps = String.to_integer(steps)

      {dir, steps, color}
    end)
  end
end
