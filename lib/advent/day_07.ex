defmodule Advent.Day07 do
  @moduledoc """
  Day 07
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.sort_by(&rankable_hand(&1.cards))
    |> Enum.with_index(1)
    |> Enum.map(fn {hand, index} -> hand.bid * index end)
    |> Enum.sum()
  end

  defp rankable_hand(cards) do
    [cards |> calc_type() |> rankable_type(), cards]
  end

  defp calc_type(cards) do
    cards
    |> Enum.group_by(& &1)
    |> Enum.map(fn {_card, group} -> Enum.count(group) end)
    |> Enum.sort()
    |> case do
      [5] -> :five_of_a_kind
      [1, 4] -> :four_of_a_kind
      [2, 3] -> :full_house
      [1, 1, 3] -> :three_of_a_kind
      [1, 2, 2] -> :two_pairs
      [1, 1, 1, 2] -> :one_pair
      [1, 1, 1, 1, 1] -> :high_card
    end
  end

  defp rankable_type(:high_card), do: 1
  defp rankable_type(:one_pair), do: 2
  defp rankable_type(:two_pairs), do: 3
  defp rankable_type(:three_of_a_kind), do: 4
  defp rankable_type(:full_house), do: 5
  defp rankable_type(:four_of_a_kind), do: 6
  defp rankable_type(:five_of_a_kind), do: 7

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
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [cards, bid] = line |> String.split(" ")

    %{
      cards: parse_cards(cards),
      bid: String.to_integer(bid)
    }
  end

  defp parse_cards(cards) do
    cards
    |> String.split("", trim: true)
    |> Enum.map(&parse_card/1)
  end

  defp parse_card("2"), do: 2
  defp parse_card("3"), do: 3
  defp parse_card("4"), do: 4
  defp parse_card("5"), do: 5
  defp parse_card("6"), do: 6
  defp parse_card("7"), do: 7
  defp parse_card("8"), do: 8
  defp parse_card("9"), do: 9
  defp parse_card("T"), do: 10
  defp parse_card("J"), do: 11
  defp parse_card("Q"), do: 12
  defp parse_card("K"), do: 13
  defp parse_card("A"), do: 14
end
