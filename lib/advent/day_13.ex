defmodule Advent.Day13 do
  @moduledoc """
  Day 13
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&summary/1)
    |> Enum.sum()
  end

  defp summary(map) do
    horizontal_mirror = map |> find_mirror() || 0
    vertical_mirror = map |> transpose() |> find_mirror() || 0

    vertical_mirror + 100 * horizontal_mirror
  end

  defp transpose(map) do
    map
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp find_mirror([row | rows]) do
    find_mirror([row], rows)
  end

  defp find_mirror(_, []), do: nil

  defp find_mirror(left, right) do
    left
    |> Enum.zip(right)
    |> Enum.all?(fn {a, b} -> a == b end)
    |> case do
      true ->
        length(left)

      false ->
        [elem | right] = right
        find_mirror([elem | left], right)
    end
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
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_map/1)
  end

  defp parse_map(map_input) do
    map_input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(fn
        "." -> :ash
        "#" -> :rocks
      end)
    end)
  end
end
