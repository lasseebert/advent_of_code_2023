defmodule Advent.Day12 do
  @moduledoc """
  Day 12
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&count_combinations/1)
    |> Enum.sum()
  end

  defp count_combinations({conditions, groups}) do
    zipper = {[], conditions}
    count(zipper, groups)
  end

  defp count({left, []}, groups) do
    left
    |> Enum.reverse()
    |> Enum.chunk_by(& &1)
    |> Enum.flat_map(fn
      [:good | _] -> []
      [:damaged | _] = list -> [length(list)]
    end)
    |> then(&(&1 == groups))
    |> case do
      true -> 1
      false -> 0
    end
  end

  defp count(zipper, groups) do
    {[elem | left], right} = zipper = zipper |> zipper_right()

    case elem do
      :unknown ->
        count_1 = {[:damaged | left], right} |> count(groups)
        count_2 = {[:good | left], right} |> count(groups)
        count_1 + count_2

      _ ->
        zipper |> count(groups)
    end
  end

  defp zipper_right({left, [elem | right]}) do
    {[elem | left], right}
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
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [conditions, groups] = String.split(line, " ")

    {
      parse_conditions(conditions),
      parse_groups(groups)
    }
  end

  defp parse_conditions(conditions) do
    conditions
    |> String.graphemes()
    |> Enum.map(fn
      "#" -> :damaged
      "." -> :good
      "?" -> :unknown
    end)
  end

  defp parse_groups(groups) do
    groups
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
