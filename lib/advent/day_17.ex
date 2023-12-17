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
    target = map |> Map.keys() |> Enum.max()
    start = {{0, 0}, {1, 0}, 0}

    a_star(map, start, target)
  end

  # Note that each tile of the map is 12 nodes in the A* graph. This is because
  # of the limitations in movement. You can only move straight for 1-3 tiles, and
  # you can only turn left or right.
  defp a_star(map, start, target) do
    # Optimally this should be a heap or a priority queue
    # This would make the select-min happen in O(log n) instead of O(n)
    open = MapSet.new([start])
    g_score = %{start => 0}

    a_star_loop(map, open, g_score, target)
  end

  defp a_star_loop(map, open, g_score, target) do
    current_node =
      Enum.min_by(open, fn node -> Map.fetch!(g_score, node) + h_score(node, target) end)

    current_g_score = Map.fetch!(g_score, current_node)

    if current_node == target do
      current_g_score
    else
      open = MapSet.delete(open, current_node)

      {open, g_score} =
        current_node
        |> neighbours(map, target)
        |> Enum.reduce({open, g_score}, fn neighbour, {open, g_score} ->
          tentative_g_score = current_g_score + cost(neighbour, map)

          case Map.fetch(g_score, neighbour) do
            {:ok, seen_g_score} when seen_g_score <= tentative_g_score ->
              {open, g_score}

            _ ->
              open = MapSet.put(open, neighbour)
              g_score = Map.put(g_score, neighbour, tentative_g_score)

              {open, g_score}
          end
        end)

      a_star_loop(map, open, g_score, target)
    end
  end

  defp cost({pos, _, _}, map), do: Map.fetch!(map, pos)
  defp cost({_, _} = pos, map), do: Map.fetch!(map, pos)

  defp h_score({pos, _, _}, target), do: manhattan_distance(pos, target)
  defp h_score({_, _} = pos, target), do: manhattan_distance(pos, target)

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp neighbours(node, map, target) do
    [
      turn_left(node),
      go_straight(node),
      turn_right(node)
    ]
    |> Enum.filter(fn
      {_, _, straight_count} when straight_count > 3 -> false
      {pos, _, _} -> Map.has_key?(map, pos)
    end)
    |> Enum.map(fn
      {pos, _, _} when pos == target -> pos
      node -> node
    end)
  end

  defp turn_left({pos, dir, _straight_count}) do
    new_dir = rotate_left(dir)
    new_pos = move(pos, new_dir)
    {new_pos, new_dir, 1}
  end

  defp turn_right({pos, dir, _straight_count}) do
    new_dir = rotate_right(dir)
    new_pos = move(pos, new_dir)
    {new_pos, new_dir, 1}
  end

  defp go_straight({pos, dir, straight_count}) do
    new_pos = move(pos, dir)
    {new_pos, dir, straight_count + 1}
  end

  defp rotate_left({x, y}), do: {-y, x}
  defp rotate_right({x, y}), do: {y, -x}

  defp move({x, y}, {dx, dy}) do
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
