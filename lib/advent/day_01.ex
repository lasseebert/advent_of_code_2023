defmodule Advent.Day01 do
  @moduledoc """
  Day 01
  """

  @digits String.graphemes("1234567890")

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&calibration_value_part_1/1)
    |> Enum.reduce(&(&1 + &2))
  end

  defp calibration_value_part_1(line) do
    line
    |> String.graphemes()
    |> Enum.filter(&(&1 in @digits))
    |> Enum.map(&String.to_integer/1)
    |> then(&(List.first(&1) * 10 + List.last(&1)))
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.map(&calibration_value_part_2/1)
    |> Enum.reduce(&(&1 + &2))
  end

  defp calibration_value_part_2(line) do
    line
    |> extract_digits([])
    |> then(&(List.first(&1) * 10 + List.last(&1)))
  end

  @digit_map %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "0" => 0
  }

  defp extract_digits("", digits), do: Enum.reverse(digits)

  Enum.each(@digit_map, fn {word, digit} ->
    defp extract_digits(unquote(word) <> rest, digits) do
      # We reuse the word except for the first letter, so we can use the rest of the word
      # as the beginning of another word.
      extract_digits(String.slice(unquote(word), 1..-1) <> rest, [unquote(digit) | digits])
    end
  end)

  defp extract_digits(<<_::binary-size(1), rest::binary>>, digits) do
    extract_digits(rest, digits)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
  end
end
