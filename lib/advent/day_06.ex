defmodule Advent.Day06 do
  @moduledoc """
  Day 06
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(fn {time, record} -> num_ways_to_win(time, record) end)
    |> Enum.reduce(1, &Kernel.*/2)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> String.replace(" ", "")
    |> parse()
    |> then(fn [{time, record}] -> num_ways_to_win(time, record) end)
  end

  defp num_ways_to_win(time, record) do
    # We want to find the number of ways to beat the record

    # Terms:
    #   d = distance
    #   t = time
    #   t' = time actually moving
    #   r = record
    #   p = press time
    #   v = velocity

    # So we want to find number of p so d > r and p is integer

    # The travelled distance is
    #   d = v * t'
    #     = p * (t - p)
    #     = -p² + tp

    # So we want to find the number of p so -p² + tp > r and p is integer
    #  -p² + tp - r > 0

    # We solve for equality and find number of integer solutions between the
    # two hits, since this is a parabola with a negative coefficient.

    # p = (-t ± √(t² - 4(-1)(-r))) / 2(-1)
    #   = (-t ± √(t² - 4r)) / -2
    #   = (t ± √(t² - 4r)) / 2

    det = time * time - 4 * record

    if det < 0 do
      0
    else
      p1 = (time - :math.sqrt(det)) / 2
      p2 = (time + :math.sqrt(det)) / 2

      # First integer after p1
      p1 = Float.floor(p1 + 1)
      # Last integer before p2
      p2 = Float.ceil(p2 - 1)

      trunc(p2 - p1 + 1)
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, numbers] = String.split(line, ":", trim: true)

      numbers
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
  end
end
