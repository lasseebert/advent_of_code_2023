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
    input
    |> parse()

    0
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
      [node, left, right] = Regex.run(~r/([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)/, line, capture: :all_but_first)
      {node, {left, right}}
    end)
  end
end
