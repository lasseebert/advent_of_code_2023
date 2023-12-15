defmodule Advent.Day15 do
  @moduledoc """
  Day 15
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  def hash(string) do
    string
    |> String.graphemes()
    |> Enum.reduce(0, fn char, acc ->
      char
      |> ascii()
      |> Kernel.+(acc)
      |> Kernel.*(17)
      |> rem(256)
    end)
  end

  def ascii(char) do
    char
    |> String.to_charlist()
    |> hd()
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
    input
    |> String.trim()
    |> String.split(",", trim: true)
  end
end
