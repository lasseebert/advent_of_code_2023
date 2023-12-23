defmodule Advent.Graph do
  @moduledoc """
  Directional non-neg-integer-weighted graph
  """

  use TypedStruct

  typedstruct do
    field :vertices, MapSet.t(vertex()), default: MapSet.new()
    field :edges, %{vertex() => [edge]}, default: %{}
    field :reverse_edges, %{vertex() => [{vertex(), weight()}]}, default: %{}
  end

  @type edge :: {vertex(), weight()}
  @type vertex() :: any()
  @type weight() :: non_neg_integer()

  @doc """
  Create a new empty graph
  """
  @spec new() :: t
  def new do
    %__MODULE__{}
  end

  @doc """
  Adds an edge to the graph
  """
  @spec add_edge(t, vertex(), vertex(), weight()) :: t
  def add_edge(graph, source, target, weight) do
    graph =
      graph
      |> add_vertex(source)
      |> add_vertex(target)

    edges = Map.update!(graph.edges, source, &[{target, weight} | &1])
    reverse_edges = Map.update!(graph.reverse_edges, target, &[{source, weight} | &1])

    %__MODULE__{graph | edges: edges, reverse_edges: reverse_edges}
  end

  @doc """
  Adds a vertex to the graph
  """
  @spec add_vertex(t, vertex()) :: t
  def add_vertex(graph, vertex) do
    if MapSet.member?(graph.vertices, vertex) do
      graph
    else
      vertices = MapSet.put(graph.vertices, vertex)
      edges = Map.put(graph.edges, vertex, [])
      reverse_edges = Map.put(graph.reverse_edges, vertex, [])

      %__MODULE__{graph | vertices: vertices, edges: edges, reverse_edges: reverse_edges}
    end
  end

  @doc """
  Removes a vertex and all edges connected to it from the graph
  """
  @spec remove_vertex(t, vertex()) :: t
  def remove_vertex(graph, vertex) do
    v_edges = Map.fetch!(graph.edges, vertex)
    v_reverse_edges = Map.fetch!(graph.reverse_edges, vertex)

    graph =
      v_edges
      |> Enum.reduce(graph, fn {v, _w}, graph -> remove_edge(graph, vertex, v) end)

    graph =
      v_reverse_edges
      |> Enum.reduce(graph, fn {v, _w}, graph -> remove_edge(graph, v, vertex) end)

    vertices = MapSet.delete(graph.vertices, vertex)
    edges = Map.delete(graph.edges, vertex)
    reverse_edges = Map.delete(graph.reverse_edges, vertex)

    %__MODULE__{graph | vertices: vertices, edges: edges, reverse_edges: reverse_edges}
  end

  @doc """
  Removes all edges and vertices from the graph that is not needed to traverse
  the graph between the given vertices. When a vertex B is removed from
  A->B->C, the edge A->C is added instead.
  """
  @spec minimize(t, MapSet.t()) :: t
  def minimize(graph, keep) do
    graph
    |> remove_dead_ends(keep)
  end

  defp remove_dead_ends(graph, keep) do
    worklist = MapSet.to_list(graph.vertices)

    remove_dead_ends(graph, keep, worklist)
  end

  defp remove_dead_ends(graph, _keep, []), do: graph

  defp remove_dead_ends(graph, keep, [vertex | worklist]) do
    if MapSet.member?(keep, vertex) or not MapSet.member?(graph.vertices, vertex) do
      remove_dead_ends(graph, keep, worklist)
    else
      out_edges = graph.edges |> Map.fetch!(vertex) |> Enum.map(fn {v, _w} -> v end) |> Enum.sort()
      in_edges = graph.reverse_edges |> Map.fetch!(vertex) |> Enum.map(fn {v, _w} -> v end) |> Enum.sort()

      case {in_edges, out_edges} do
        {[], _} ->
          # No inputs
          graph
          |> remove_vertex(vertex)
          |> remove_dead_ends(keep, worklist)

        {_, []} ->
          # No outputs
          graph
          |> remove_vertex(vertex)
          |> remove_dead_ends(keep, worklist)

        {[a], [a]} ->
          # Dead end
          graph
          |> remove_vertex(vertex)
          |> remove_dead_ends(keep, worklist)

        {[_, _ | _] = in_edges, [out_edge]} ->
          if out_edge in in_edges do
            # Single input that can be deleted
            graph
            |> remove_edge(out_edge, vertex)
            |> remove_dead_ends(keep, in_edges ++ [vertex, out_edge | worklist])
          else
            graph
            |> remove_dead_ends(keep, worklist)
          end

        {[in_edge], [_, _ | _] = out_edges} ->
          if in_edge in out_edges do
            # Single output that can be deleted
            graph
            |> remove_edge(vertex, in_edge)
            |> remove_dead_ends(keep, out_edges ++ [vertex, in_edge | worklist])
          else
            graph
            |> remove_dead_ends(keep, worklist)
          end

        {[a, b] = edges, edges} ->
          # Double directed pass-through node
          a_vertex = graph.edges |> Map.fetch!(a) |> Enum.find(fn {v, _w} -> v == vertex end) |> elem(1)
          b_vertex = graph.edges |> Map.fetch!(b) |> Enum.find(fn {v, _w} -> v == vertex end) |> elem(1)
          vertex_a = graph.edges |> Map.fetch!(vertex) |> Enum.find(fn {v, _w} -> v == a end) |> elem(1)
          vertex_b = graph.edges |> Map.fetch!(vertex) |> Enum.find(fn {v, _w} -> v == b end) |> elem(1)

          graph
          |> add_edge(a, b, a_vertex + vertex_b)
          |> add_edge(b, a, b_vertex + vertex_a)
          |> remove_vertex(vertex)
          |> remove_dead_ends(keep, [a, b | worklist])

        {[a], [b]} ->
          # Single directed pass-through node
          a_vertex = graph.edges |> Map.fetch!(a) |> Enum.find(fn {v, _w} -> v == vertex end) |> elem(1)
          vertex_b = graph.edges |> Map.fetch!(vertex) |> Enum.find(fn {v, _w} -> v == b end) |> elem(1)

          graph
          |> add_edge(a, b, a_vertex + vertex_b)
          |> remove_vertex(vertex)
          |> remove_dead_ends(keep, [a, b | worklist])

        _ ->
          graph |> remove_dead_ends(keep, worklist)
      end
    end
  end

  defp remove_edge(graph, source, target) do
    edges =
      Map.update!(graph.edges, source, fn edges ->
        edges |> Enum.reject(fn {v, _w} -> v == target end)
      end)

    reverse_edges =
      Map.update!(graph.reverse_edges, target, fn edges ->
        edges |> Enum.reject(fn {v, _w} -> v == source end)
      end)

    %__MODULE__{graph | edges: edges, reverse_edges: reverse_edges}
  end
end
