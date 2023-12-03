defmodule Advent.Day03 do
  @moduledoc """
  Day 03
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> find_numbers_with_parts()
    |> Enum.reject(fn {_number, parts} -> parts == [] end)
    |> Enum.map(fn {number, _parts} -> number end)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
  end

  defp find_numbers_with_parts(map) do
    max_x = map |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    max_y = map |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    find_numbers_with_parts(map, {0, 0}, {max_x, max_y}, [])
  end

  defp find_numbers_with_parts(_map, {_x, y}, {_max_x, max_y}, numbers) when y > max_y do
    numbers
  end

  defp find_numbers_with_parts(map, {x, y}, {max_x, max_y}, numbers) when x > max_x do
    find_numbers_with_parts(map, {0, y + 1}, {max_x, max_y}, numbers)
  end

  defp find_numbers_with_parts(map, {x, y} = pos, max, numbers) do
    case Map.fetch(map, pos) do
      {:ok, {:digit, digit}} ->
        {next_pos, number} = read_number(map, {x + 1, y}, digit)
        parts = find_adjacent_parts(map, {x - 1, y}, next_pos)
        find_numbers_with_parts(map, next_pos, max, [{number, parts} | numbers])

      {:ok, _other} ->
        find_numbers_with_parts(map, {x + 1, y}, max, numbers)
    end
  end

  defp read_number(map, {x, y} = pos, number) do
    case Map.fetch(map, pos) do
      {:ok, {:digit, digit}} ->
        read_number(map, {x + 1, y}, number * 10 + digit)

      _other_or_error ->
        {pos, number}
    end
  end

  defp find_adjacent_parts(map, {min_x, y}, {max_x, y}) do
    [
      {min_x, y},
      {max_x, y},
      Enum.map(min_x..max_x, &{&1, y - 1}),
      Enum.map(min_x..max_x, &{&1, y + 1})
    ]
    |> List.flatten()
    |> Enum.flat_map(fn pos ->
      case Map.fetch(map, pos) do
        {:ok, {:symbol, symbol}} -> [{pos, symbol}]
        _other -> []
      end
    end)
  end

  @digits "0123456789" |> String.graphemes()

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} -> parse_char(char, x, y) end)
    end)
    |> Enum.into(%{})
  end

  defp parse_char(char, x, y) do
    value =
      case char do
        digit when digit in @digits -> {:digit, String.to_integer(digit)}
        "." -> {:empty, nil}
        symbol -> {:symbol, symbol}
      end

    {{x, y}, value}
  end
end
