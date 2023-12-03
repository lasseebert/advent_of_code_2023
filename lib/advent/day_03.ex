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
    |> find_part_numbers()
    |> Enum.sum()
  end

  defp find_part_numbers(map) do
    max_x = map |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    max_y = map |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    find_part_numbers(map, {0, 0}, {max_x, max_y}, [])
  end

  defp find_part_numbers(_map, {_x, y}, {_max_x, max_y}, part_numbers) when y > max_y do
    part_numbers
  end

  defp find_part_numbers(map, {x, y}, {max_x, max_y}, part_numbers) when x > max_x do
    find_part_numbers(map, {0, y + 1}, {max_x, max_y}, part_numbers)
  end

  defp find_part_numbers(map, {x, y} = pos, max, part_numbers) do
    case Map.fetch(map, pos) do
      {:ok, {:digit, digit}} ->
        {next_pos, number} = read_number(map, {x + 1, y}, digit)

        if number_adjacent_to_symbol?(map, {x - 1, y}, next_pos) do
          find_part_numbers(map, next_pos, max, [number | part_numbers])
        else
          find_part_numbers(map, next_pos, max, part_numbers)
        end

      {:ok, _other} ->
        find_part_numbers(map, {x + 1, y}, max, part_numbers)
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

  defp number_adjacent_to_symbol?(map, {min_x, y}, {max_x, y}) do
    [
      {min_x, y},
      {max_x, y},
      Enum.map(min_x..max_x, &{&1, y - 1}),
      Enum.map(min_x..max_x, &{&1, y + 1})
    ]
    |> List.flatten()
    |> Enum.any?(fn pos ->
      case Map.fetch(map, pos) do
        {:ok, {:symbol, _}} -> true
        _other -> false
      end
    end)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
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
