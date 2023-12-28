defmodule Advent.Day25 do
  @moduledoc """
  Day 25
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> build_edges()
    |> min_cut()
    |> then(fn {s1, s2} ->
      length(s1) * length(s2)
    end)
  end

  # Implementation of Stoer-Wagner algorithm
  # https://en.wikipedia.org/wiki/Stoer%E2%80%93Wagner_algorithm
  defp min_cut(edges) do
    min_cut_weight = nil
    min_cut = nil

    a = edges |> Map.keys() |> hd()

    stoer_wagner(edges, a, min_cut_weight, min_cut)
  end

  defp stoer_wagner(edges, a, min_cut_weight, min_cut) do
    phase = phase(edges, a)

    [last, second_to_last | rest] = phase

    weight = edges |> Map.fetch!(last) |> Map.values() |> Enum.sum()

    {min_cut_weight, min_cut} =
      if min_cut_weight == nil or weight < min_cut_weight do
        {
          weight,
          {
            List.flatten([last]),
            List.flatten([second_to_last | rest])
          }
        }
      else
        {min_cut_weight, min_cut}
      end

    if min_cut_weight == 3 do
      min_cut
    else
      edges = merge(edges, second_to_last, last)
      stoer_wagner(edges, a, min_cut_weight, min_cut)
    end
  end

  defp merge(edges, v1, v2) do
    edges_1 = edges |> Map.fetch!(v1) |> Map.delete(v2)
    edges_2 = edges |> Map.fetch!(v2) |> Map.delete(v1)
    merged_edges = Map.merge(edges_1, edges_2, fn _v, w1, w2 -> w1 + w2 end)
    merged_vertex = [v1, v2] |> Enum.sort()

    edges =
      edges
      |> Map.delete(v1)
      |> Map.delete(v2)
      |> Map.put(merged_vertex, merged_edges)

    merged_edges
    |> Map.keys()
    |> Enum.reduce(edges, fn v, edges ->
      edges
      |> Map.update!(v, fn v_edges ->
        v_edges
        |> Map.delete(v1)
        |> Map.delete(v2)
        |> Map.put(merged_vertex, Map.fetch!(merged_edges, v))
      end)
    end)
  end

  defp phase(edges, a) do
    vertices = edges |> Map.keys() |> List.delete(a)
    phase_loop(edges, [a], MapSet.new([a]), vertices)
  end

  defp phase_loop(_edges, phase, _phase_set, []), do: phase

  defp phase_loop(edges, phase, phase_set, vertices) do
    # Find the vertex not in the phase with the most weight into the phase.
    # This is the crucual part to get a good running time and must be implemented
    # with a priority queue to get O(|V| log |V|) instead of O(|V|^2)
    v =
      vertices
      |> Enum.map(fn v ->
        w =
          edges
          |> Map.fetch!(v)
          |> Enum.filter(fn {v, _} -> v in phase_set end)
          |> Enum.map(fn {_, weight} -> weight end)
          |> Enum.sum()

        {v, w}
      end)
      |> Enum.max_by(fn {_, w} -> w end)
      |> elem(0)

    phase_loop(edges, [v | phase], MapSet.put(phase_set, v), List.delete(vertices, v))
  end

  defp build_edges(nodes) do
    nodes
    |> Enum.flat_map(fn {source, targets} -> Enum.map(targets, &{source, &1}) end)
    |> Enum.reduce(%{}, fn {source, target}, graph ->
      graph
      |> Map.update(source, %{target => 1}, &Map.put(&1, target, 1))
      |> Map.update(target, %{source => 1}, &Map.put(&1, source, 1))
    end)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [source, targets] = line |> String.split(": ")
    targets = targets |> String.split(" ")
    {source, targets}
  end
end
