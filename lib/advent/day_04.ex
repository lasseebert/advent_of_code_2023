defmodule Advent.Day04 do
  @moduledoc """
  Day 04
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&points/1)
    |> Enum.sum()
  end

  defp points(%{winners: winners, numbers: numbers}) do
    numbers
    |> Enum.count(&MapSet.member?(winners, &1))
    |> case do
      0 -> 0
      n -> pow(2, n - 1)
    end
  end

  defp pow(_base, 0), do: 1
  defp pow(base, n), do: base * pow(base, n - 1)

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
    |> Enum.map(&parse_card/1)
  end

  defp parse_card(card) do
    card
    |> String.split(": ")
    |> then(fn [_, numbers] -> numbers end)
    |> String.split(" | ")
    |> Enum.map(&parse_numbers/1)
    |> then(fn [winners, numbers] ->
      %{winners: MapSet.new(winners), numbers: numbers}
    end)
  end

  defp parse_numbers(numbers) do
    numbers
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
