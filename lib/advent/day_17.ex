defmodule Advent.Day17 do
  @moduledoc """
  Day 17
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    map = input |> parse()
    current = {{0, 0}, {1, 0}, 0}
    cost = 0
    seen = %{}
    target = map |> Map.keys() |> Enum.max()

    seen = traverse(seen, map, current, cost)

    seen
    |> Enum.filter(fn {{pos, _, _}, _cost} -> pos == target end)
    |> Enum.map(fn {_, cost} -> cost end)
    |> Enum.min()
  end

  # This is a totally naive flood-fill algorithm.
  # I should use A* if it's too slow.
  # Update: It is too slow. Didn't finish after ~5 minutes :(
  def traverse(seen, map, current, cost) do
    case Map.fetch(seen, current) do
      {:ok, seen_cost} when seen_cost <= cost ->
        seen

      _ ->
        seen = Map.put(seen, current, cost)

        [
          turn_left(current),
          go_straight(current),
          turn_right(current)
        ]
        |> Enum.filter(fn
          {_, _, straight_count} when straight_count > 3 -> false
          {pos, _, _} -> Map.has_key?(map, pos)
        end)
        |> Enum.reduce(seen, fn {pos, _, _} = new_current, seen ->
          move_cost = Map.fetch!(map, pos)
          traverse(seen, map, new_current, cost + move_cost)
        end)
    end
  end

  def turn_left({pos, dir, _straight_count}) do
    new_dir = rotate_left(dir)
    new_pos = move(pos, new_dir)
    {new_pos, new_dir, 1}
  end

  def turn_right({pos, dir, _straight_count}) do
    new_dir = rotate_right(dir)
    new_pos = move(pos, new_dir)
    {new_pos, new_dir, 1}
  end

  def go_straight({pos, dir, straight_count}) do
    new_pos = move(pos, dir)
    {new_pos, dir, straight_count + 1}
  end

  def rotate_left({x, y}), do: {-y, x}
  def rotate_right({x, y}), do: {y, -x}

  def move({x, y}, {dx, dy}) do
    {x + dx, y + dy}
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
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} -> {{x, y}, String.to_integer(char)} end)
    end)
    |> Enum.into(%{})
  end
end
