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
    horizontal_mirror = map |> find_mirror(nil) || 0
    vertical_mirror = map |> transpose() |> find_mirror(nil) || 0

    vertical_mirror + 100 * horizontal_mirror
  end

  defp find_mirror([row | rows], exclude) do
    find_mirror([row], rows, exclude)
  end

  defp find_mirror(_, [], _exclude), do: nil

  defp find_mirror(left, right, exclude) do
    left
    |> Enum.zip(right)
    |> Enum.all?(fn {a, b} -> a == b end)
    |> case do
      true ->
        mirror = length(left)

        if exclude == mirror do
          [elem | right] = right
          find_mirror([elem | left], right, exclude)
        else
          mirror
        end

      false ->
        [elem | right] = right
        find_mirror([elem | left], right, exclude)
    end
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.map(&smudge_summary/1)
    |> Enum.sum()
  end

  defp smudge_summary(map) do
    original_horizontal_mirror = map |> find_mirror(nil)
    original_vertical_mirror = map |> transpose() |> find_mirror(nil)

    horizontal_mirror = map |> find_smudge_mirror(original_horizontal_mirror) || 0
    vertical_mirror = map |> transpose() |> find_smudge_mirror(original_vertical_mirror) || 0

    vertical_mirror + 100 * horizontal_mirror
  end

  defp find_smudge_mirror(map, original_mirror) do
    for(y <- 0..(length(map) - 1), x <- 0..(length(hd(map)) - 1), do: {x, y})
    |> Stream.map(fn {x, y} ->
      List.update_at(map, y, fn row ->
        List.update_at(row, x, fn
          :ash -> :rocks
          :rocks -> :ash
        end)
      end)
    end)
    |> Stream.map(fn [row | rows] -> find_mirror([row], rows, original_mirror) end)
    |> Enum.find(& &1)
  end

  defp transpose(map) do
    map
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
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
