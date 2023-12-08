defmodule Advent.Day08 do
  @moduledoc """
  Day 08
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {instructions, network} = input |> parse()

    instructions
    |> Stream.cycle()
    |> Stream.transform("AAA", fn instruction, node ->
      {left, right} = Map.fetch!(network, node)

      next_node =
        case instruction do
          :left -> left
          :right -> right
        end

      {[node], next_node}
    end)
    |> Stream.with_index(0)
    |> Enum.find(fn {node, _count} -> node == "ZZZ" end)
    |> then(fn {_node, count} -> count end)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    {instructions, network} = input |> parse()

    network
    |> Map.keys()
    |> Enum.filter(fn node -> String.ends_with?(node, "A") end)
    |> Enum.map(fn node -> find_cycle(node, instructions, network) end)
    |> Enum.reduce(&combine_cycles/2)
    |> then(fn {0, length} -> length end)
  end

  # Finds the cycle from a given starting node.
  # E.g. if the node stream produces the following nodes:
  #
  #   A, B, C, D, Z, E
  #
  # And then repeats from B again, the cycle length is 5 and the offset to the first Z is 4
  defp find_cycle(node, instructions, network) do
    instructions
    |> Enum.with_index()
    |> Stream.cycle()
    |> Stream.transform(node, fn {instruction, instruction_index}, node ->
      {left, right} = Map.fetch!(network, node)

      next_node =
        case instruction do
          :left -> left
          :right -> right
        end

      {[{node, instruction_index}], next_node}
    end)
    |> Stream.with_index()
    |> Enum.reduce_while(%{}, fn {state, index}, seen ->
      case Map.fetch(seen, state) do
        {:ok, seen_index} ->
          hit_index =
            seen
            |> Enum.sort_by(fn {_state, index} -> index end)
            |> Enum.map(fn {{node, _instruction_index}, index} -> {node, index} end)
            |> Enum.filter(fn {node, _index} -> String.ends_with?(node, "Z") end)
            |> Enum.map(fn {_node, index} -> index end)
            # Seems to work to just pick the last one
            # In the puzzle input there are no starting points that has multiple Z hits,
            # In the small example input there is.
            |> List.last()

          offset = hit_index
          length = Enum.count(seen) - seen_index

          {
            :halt,
            {offset, length}
          }

        :error ->
          {:cont, Map.put(seen, state, index)}
      end
    end)
  end

  # Combines two cycles into a single cycle
  # Stolen from https://math.stackexchange.com/a/3864593
  defp combine_cycles({offset_1, length_1}, {offset_2, length_2}) do
    {gcd, s, _t} = extended_gcd(length_1, length_2)
    offset_diff = offset_1 - offset_2

    pd_mult = div(offset_diff, gcd)
    pd_remainder = rem(offset_diff, gcd)

    if pd_remainder != 0 do
      raise "Cycles never synchronize"
    end

    combined_length = div(length_1, gcd) * length_2
    combined_offset = rem(offset_1 - s * pd_mult * length_1, combined_length)

    {combined_offset, combined_length}
  end

  # Extended Euclidean algorithm
  # Returns:
  #   d = gcd(a, b)
  #   s and t so that gcd(a, b) = sa + tb
  defp extended_gcd(a, b) do
    case b do
      0 ->
        {a, 1, 0}

      _ ->
        {d, s, t} = extended_gcd(b, rem(a, b))
        {d, t, s - div(a, b) * t}
    end
  end

  defp parse(input) do
    [instructions, network] =
      input
      |> String.trim()
      |> String.split("\n\n", trim: true)

    {
      parse_instructions(instructions),
      parse_network(network)
    }
  end

  defp parse_instructions(instructions) do
    instructions
    |> String.graphemes()
    |> Enum.map(fn
      "L" -> :left
      "R" -> :right
    end)
  end

  defp parse_network(network) do
    network
    |> String.split("\n", trim: true)
    |> Enum.into(%{}, fn line ->
      [node, left, right] =
        Regex.run(~r/([A-Z0-9]{3}) = \(([A-Z0-9]{3}), ([A-Z0-9]{3})\)/, line, capture: :all_but_first)

      {node, {left, right}}
    end)
  end
end
