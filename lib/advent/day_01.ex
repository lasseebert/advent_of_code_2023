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
    |> Enum.map(&calibration_value/1)
    |> Enum.reduce(&(&1 + &2))
  end

  defp calibration_value(line) do
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
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
  end
end
