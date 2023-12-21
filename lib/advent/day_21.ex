defmodule Advent.Day21 do
  @moduledoc """
  Day 21
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t(), pos_integer) :: integer
  def part_1(input, steps \\ 64) do
    solve(input, steps)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t(), pos_integer) :: integer
  def part_2(input, steps \\ 26_501_365) do
    solve(input, steps)
  end

  defp solve(input, steps) do
    {map, start} = input |> parse()

    size_x = map |> Enum.map(fn {x, _} -> x end) |> Enum.max() |> Kernel.+(1)
    size_y = map |> Enum.map(fn {_, y} -> y end) |> Enum.max() |> Kernel.+(1)
    dims = {size_x, size_y}

    # Since there are open spaces all around the edges of the map, we can eventually
    # get from one map to the next (in infinite mode) in the same number of steps as
    # the size of the map. This will lead to a cycle of quadratic numbers.
    true = size_x == size_y
    cycle_length = size_x

    # We only need to count only the odd or event distances, depending on whether the
    # steps is odd or even.
    rem_2 = rem(steps, 2)

    # A stream that yields the number of tiles we can visit and the distance so far.
    # Each result from the stream is two steps (odd or even)
    layer_stream =
      Stream.unfold({[start], 0, %{}, 0}, fn {coords, distance, visited, total} ->
        total =
          if rem(distance, 2) == rem_2 do
            total + length(coords)
          else
            total
          end

        {next_coords, next_visited} = walk_one_layer(coords, [], distance, visited, map, dims)
        {{total, distance}, {next_coords, distance + 1, next_visited, total}}
      end)
      |> Stream.drop(rem_2)
      |> Stream.take_every(2)

    # Since we move two steps at a time in the stream, we multiply the cycle length by 2.
    # This is the number of steps we need to take first for a full number of cycles to be left.
    steps_first_cycle = rem(steps, cycle_length * 2)

    if steps_first_cycle == steps do
      # Special case: We move so few steps we don't need to worry about cycles
      layer_stream
      |> Enum.at(div(steps, 2))
      |> elem(0)
    else
      layer_stream
      |> Stream.drop(div(steps_first_cycle, 2))
      |> Stream.take_every(cycle_length)
      |> Stream.chunk_every(4, 1, :discard)
      |> Stream.map(fn [{a, _}, {b, _}, {c, _}, {d, dist}] -> {{a, b, c, d}, dist} end)
      # {a, b, c, d} are four consecutive numbers of visited tiles.
      # We want to find a "quadratic" cycle.
      #
      # For a linear cycle, we sould look for a constant linear increase like this.
      # Diffs between numbers are written below. When we have a zero diff, we have a cycle.
      #
      #   3   4   6   8   10
      #     1   2   2   2
      #       1   0   0
      #
      # For quadratic cycles, we look for the same thing, but we need to go one level further down,
      # which is why we need four numbers.
      #
      # To get the sum we want to be zero, we calculate second layer:
      #
      #   b - a, c - b, d - c
      #
      # Then third layer:
      #
      #   (c - b) - (b - a), (d - c) - (c - b)
      #
      # Then the last layer:
      #
      #   ((d - c) - (c - b)) - ((c - b) - (b - a))
      #   = d - 3c + 3b - a
      |> Enum.find(fn {{a, b, c, d}, _dist} -> d - 3 * c + 3 * b - a == 0 end)
      |> then(fn {{_a, b, c, d}, dist} ->
        # Now that we have the numbers, we need to first figure out how many full cycles we have
        # left:
        x = div(steps - dist, cycle_length * 2)

        # Then we calculate the first layer value at that many iterations forward:
        #
        # * Layer 1 is not repeated (we only add to it)
        # * Layer 2 is repeated exactly x times
        # * Layer 3 is repeated exactly x * (x + 1) / 2 times (sum of 1..x)
        l1 = d
        l2 = d - c
        l3 = d - 2 * c + b

        l1 + l2 * x + div(l3 * x * (x + 1), 2)
      end)
    end
  end

  defp walk_one_layer([], next_coords, _distance, visited, _map, _dims) do
    {Enum.uniq(next_coords), visited}
  end

  defp walk_one_layer([coord | coords], next_coords, distance, visited, map, dims) do
    visited = Map.put(visited, coord, distance)

    next_coords =
      coord
      |> neighbours(map, visited, dims)
      |> Enum.reduce(next_coords, &[&1 | &2])

    walk_one_layer(coords, next_coords, distance, visited, map, dims)
  end

  defp neighbours({x, y}, map, visited, dims) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.filter(fn coord -> on_map?(coord, map, dims) and not Map.has_key?(visited, coord) end)
  end

  defp on_map?({x, y}, map, {size_x, size_y}) do
    map_x = rem(rem(x, size_x) + size_x, size_x)
    map_y = rem(rem(y, size_y) + size_y, size_y)

    MapSet.member?(map, {map_x, map_y})
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

    [start] =
      map
      |> Enum.filter(fn {_, type} -> type == :start end)
      |> Enum.map(fn {coord, _} -> coord end)

    open =
      map
      |> Enum.filter(fn {_, type} -> type == :open end)
      |> Enum.map(fn {coord, _} -> coord end)
      |> MapSet.new()
      |> MapSet.put(start)

    {open, start}
  end
end
