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
    {seeds, maps} = input |> parse()

    seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start, length] -> start..(start + length - 1) end)
    |> Enum.flat_map(fn range -> run_range_maps(range, maps) end)
    |> Enum.min()
    |> then(& &1.first)
  end

  defp run_range_maps(range, []), do: [range]

  defp run_range_maps(range, [map | maps]) do
    range
    |> range_lookup(map)
    |> Enum.flat_map(fn range -> run_range_maps(range, maps) end)
  end

  defp range_lookup(range, []), do: [range]

  defp range_lookup(source_range, [{map_range, shift} = table | tables]) do
    case split_range(source_range, map_range) do
      [source_range] ->
        if source_range.first in map_range do
          [Range.shift(source_range, shift)]
        else
          range_lookup(source_range, tables)
        end

      source_ranges ->
        Enum.flat_map(source_ranges, fn range -> range_lookup(range, [table | tables]) end)
    end
  end

  defp split_range(r1, r2) do
    cond do
      # <--->
      #       <--->
      r1.last < r2.first ->
        [r1]

      #       <--->
      # <--->
      r1.first > r2.last ->
        [r1]

      #   <--->
      # <------->
      r1.first >= r2.first and r1.last <= r2.last ->
        [r1]

      # <---->
      #   <----->
      r1.first < r2.first and r1.last <= r2.last ->
        [
          r1.first..(r2.first - 1),
          r2.first..r1.last
        ]

      # <------->
      #   <--->
      r1.first < r2.first and r1.last > r2.last ->
        [
          r1.first..(r2.first - 1),
          r2,
          (r2.last + 1)..r1.last
        ]

      #   <----->
      # <---->
      true ->
        [
          r1.first..r2.last,
          (r2.last + 1)..r1.last
        ]
    end
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
