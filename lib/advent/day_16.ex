defmodule Advent.Day16 do
  @moduledoc """
  Day 16
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> count_energized_fields({0, 0}, :east)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    map = input |> parse()

    {max_x, max_y} = map |> Map.keys() |> Enum.max()

    [
      Enum.flat_map(0..max_x, fn x -> [{{x, 0}, :south}, {{x, max_y}, :north}] end),
      Enum.flat_map(0..max_y, fn y -> [{{0, y}, :east}, {{max_x, y}, :west}] end),
    ]
    |> Stream.concat()
    |> Enum.map(fn {pos, dir} -> count_energized_fields(map, pos, dir) end)
    |> Enum.max()
  end

  def count_energized_fields(map, pos, dir) do
    seen = MapSet.new()
    worklist = [{pos, dir}]

    seen = traverse(seen, worklist, map)

    seen
    |> Enum.map(fn {pos, _dir} -> pos end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def traverse(seen, [], _map), do: seen

  def traverse(seen, [{pos, dir} | worklist], map) do
    if MapSet.member?(seen, {pos, dir}) do
      traverse(seen, worklist, map)
    else
      case Map.fetch(map, pos) do
        {:ok, tile} ->
          new_work =
            tile
            |> change_dir(dir)
            |> Enum.map(fn new_dir -> {move(new_dir, pos), new_dir} end)

          seen
          |> MapSet.put({pos, dir})
          |> traverse(new_work ++ worklist, map)

        :error ->
          traverse(seen, worklist, map)
      end
    end
  end

  def change_dir(:open, dir), do: [dir]
  def change_dir(:slash, :east), do: [:north]
  def change_dir(:slash, :north), do: [:east]
  def change_dir(:slash, :south), do: [:west]
  def change_dir(:slash, :west), do: [:south]
  def change_dir(:backslash, :east), do: [:south]
  def change_dir(:backslash, :south), do: [:east]
  def change_dir(:backslash, :west), do: [:north]
  def change_dir(:backslash, :north), do: [:west]
  def change_dir(:vertical_split, :south), do: [:south]
  def change_dir(:vertical_split, :north), do: [:north]
  def change_dir(:vertical_split, :east), do: [:north, :south]
  def change_dir(:vertical_split, :west), do: [:north, :south]
  def change_dir(:horizontal_split, :east), do: [:east]
  def change_dir(:horizontal_split, :west), do: [:west]
  def change_dir(:horizontal_split, :north), do: [:east, :west]
  def change_dir(:horizontal_split, :south), do: [:east, :west]

  def move(:north, {x, y}), do: {x, y - 1}
  def move(:south, {x, y}), do: {x, y + 1}
  def move(:east, {x, y}), do: {x + 1, y}
  def move(:west, {x, y}), do: {x - 1, y}

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
            "." -> :open
            "|" -> :vertical_split
            "-" -> :horizontal_split
            "/" -> :slash
            "\\" -> :backslash
          end

        {{x, y}, tile}
      end)
    end)
    |> Enum.into(%{})
  end
end
