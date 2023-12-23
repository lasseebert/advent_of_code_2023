defmodule Advent.Day23 do
  @moduledoc """
  Day 23
  """

  alias Advent.Graph

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    solve(input)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input |> String.replace(~r/[<>v^]/, ".") |> solve()
  end

  defp solve(input) do
    map = input |> parse()
    {source, target} = find_source_and_target(map)

    map
    |> graph_from_map()
    |> Graph.minimize(MapSet.new([source, target]))
    |> longest_path(source, target)
  end

  defp longest_path(graph, source, target) do
    distance = 0
    visited = MapSet.new([source])
    node = source

    longest_path_loop(graph, node, target, distance, visited)
  end

  # This try-all algorithm is slow for part 2
  defp longest_path_loop(_graph, node, target, distance, _visited) when node == target, do: distance

  defp longest_path_loop(graph, node, target, distance, visited) do
    graph.edges
    |> Map.fetch!(node)
    |> Enum.reject(fn {neighbour, _weight} -> MapSet.member?(visited, neighbour) end)
    |> Enum.map(fn {neighbour, weight} ->
      longest_path_loop(graph, neighbour, target, distance + weight, MapSet.put(visited, neighbour))
    end)
    |> case do
      [] -> 0
      results -> Enum.max(results)
    end
  end

  defp find_source_and_target(map) do
    map
    |> Enum.filter(fn {_coord, tile} -> tile == :open end)
    |> Enum.map(fn {coord, _tile} -> coord end)
    |> Enum.min_max_by(fn {_x, y} -> y end)
  end

  defp graph_from_map(map) do
    map
    |> Enum.reduce(Graph.new(), fn {coord, tile}, graph ->
      case tile do
        :open ->
          coord
          |> neighbours(map)
          |> Enum.reduce(graph, fn neighbour, graph ->
            Graph.add_edge(graph, coord, neighbour, 1)
          end)

        :wall ->
          graph

        {:slope, dir} ->
          next_coord = add(coord, dir)

          if Map.get(map, next_coord, :wall) != :wall do
            Graph.add_edge(graph, coord, next_coord, 1)
          else
            graph
          end
      end
    end)
  end

  defp add({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end

  defp neighbours({x, y}, map) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.filter(&(Map.get(map, &1, :wall) != :wall))
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
      |> Enum.map(fn {char, x} ->
        tile =
          case char do
            "#" -> :wall
            "." -> :open
            ">" -> {:slope, {1, 0}}
            "<" -> {:slope, {-1, 0}}
            "^" -> {:slope, {0, -1}}
            "v" -> {:slope, {0, 1}}
          end

        {{x, y}, tile}
      end)
    end)
    |> Enum.into(%{})
  end
end
