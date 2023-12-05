defmodule Advent.Day05 do
  @moduledoc """
  Day 05
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {seeds, maps} = input |> parse()

    seeds
    |> Enum.map(fn seed -> run_maps(seed, maps) end)
    |> Enum.min()
  end

  defp run_maps(source, []), do: source
  defp run_maps(source, [map | maps]), do: run_maps(lookup(source, map), maps)

  defp lookup(source, []), do: source

  defp lookup(source, [{range, shift} | tables]) do
    if source in range do
      source + shift
    else
      lookup(source, tables)
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
    [seeds | maps] =
      input
      |> String.trim()
      |> String.split("\n\n", trim: true)

    {
      parse_seeds(seeds),
      Enum.map(maps, &parse_map/1)
    }
  end

  defp parse_seeds(line) do
    line
    |> String.split(": ")
    |> List.last()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_map(lines) do
    lines
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.map(&parse_map_line/1)
  end

  defp parse_map_line(line) do
    [dest_start, src_start, length] =
      line
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    {src_start..(src_start + length - 1), dest_start - src_start}
  end
end
