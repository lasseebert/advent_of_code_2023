defmodule Advent.Day09 do
  @moduledoc """
  Day 09
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> sum_next_numbers()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.map(&Enum.reverse/1)
    |> sum_next_numbers()
  end

  defp sum_next_numbers(sequences) do
    sequences
    |> Enum.map(&find_next_number/1)
    |> Enum.sum()
  end

  defp find_next_number(sequence) do
    if Enum.all?(sequence, &(&1 == 0)) do
      0
    else
      next_sequence =
        sequence
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)

      next = find_next_number(next_sequence)
      List.last(sequence) + next
    end
  end


  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
