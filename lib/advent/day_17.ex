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
    start = {0, 0}
    target = map |> Map.keys() |> Enum.max()

    a_star(map, start, target, 1, 3)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    map = input |> parse()
    start = {0, 0}
    target = map |> Map.keys() |> Enum.max()

    a_star(map, start, target, 4, 10)
  end

  # Note that each tile of the map is 12 nodes in the A* graph. This is because
  # of the limitations in movement. You can only move straight for 1-3 tiles, and
  # you can only turn left or right.
  defp a_star(map, start, target, min_straight, max_straight) do
    start_h = h_score(start, target)

    {open, g_score} =
      [
        {start, {0, 1}, 0},
        {start, {0, -1}, 0},
        {start, {1, 0}, 0},
        {start, {-1, 0}, 0}
      ]
      |> Enum.reduce({PQueue2.new(), %{}}, fn node, {open, g_score} ->
        open = PQueue2.put(open, node, start_h)
        g_score = Map.put(g_score, node, 0)

        {open, g_score}
      end)

    a_star_loop(map, open, g_score, target, min_straight, max_straight)
  end

  defp a_star_loop(map, open, g_score, target, min_straight, max_straight) do
    {current_node, open} = PQueue2.pop(open)

    current_g_score = Map.fetch!(g_score, current_node)

    if current_node == target do
      current_g_score
    else
      {open, g_score} =
        current_node
        |> neighbours(map, target, min_straight, max_straight)
        |> Enum.reduce({open, g_score}, fn neighbour, {open, g_score} ->
          tentative_g_score = current_g_score + cost(neighbour, map)

          case Map.fetch(g_score, neighbour) do
            {:ok, seen_g_score} when seen_g_score <= tentative_g_score ->
              {open, g_score}

            _ ->
              open = PQueue2.put(open, neighbour, tentative_g_score + h_score(neighbour, target))
              g_score = Map.put(g_score, neighbour, tentative_g_score)

              {open, g_score}
          end
        end)

      a_star_loop(map, open, g_score, target, min_straight, max_straight)
    end
  end

  defp cost({pos, _, _}, map), do: Map.fetch!(map, pos)
  defp cost({_, _} = pos, map), do: Map.fetch!(map, pos)

  defp h_score({pos, _, _}, target), do: manhattan_distance(pos, target)
  defp h_score({_, _} = pos, target), do: manhattan_distance(pos, target)

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp neighbours({_pos, dir, straight_count} = node, map, target, min_straight, max_straight) do
    [
      turn_left(node),
      go_straight(node),
      turn_right(node)
    ]
    |> Enum.filter(fn
      {_, _, new_straight_count} when new_straight_count > max_straight -> false
      {_, new_dir, _} when new_dir != dir and straight_count < min_straight -> false
      {new_pos, _, new_straight_count} when new_pos == target -> new_straight_count >= min_straight
      {new_pos, _, _} -> Map.has_key?(map, new_pos)
    end)
    |> Enum.map(fn
      {new_pos, _, _} when new_pos == target -> target
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
