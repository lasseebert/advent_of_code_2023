defmodule Advent.Day07 do
  @moduledoc """
  Day 07
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    solve(input, :no_joker)
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    solve(input, :joker)
  end

  defp solve(input, rule) do
    input
    |> parse(rule)
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
    |> Enum.map(fn {card, group} ->
      if card == 1 do
        {:joker, Enum.count(group)}
      else
        Enum.count(group)
      end
    end)
    |> Enum.sort()
    |> case do
      [5] -> :five_of_a_kind
      [1, 4] -> :four_of_a_kind
      [2, 3] -> :full_house
      [1, 1, 3] -> :three_of_a_kind
      [1, 2, 2] -> :two_pairs
      [1, 1, 1, 2] -> :one_pair
      [1, 1, 1, 1, 1] -> :high_card
      [{:joker, 5}] -> :five_of_a_kind
      [1, {:joker, 4}] -> :five_of_a_kind
      [2, {:joker, 3}] -> :five_of_a_kind
      [1, 1, {:joker, 3}] -> :four_of_a_kind
      [3, {:joker, 2}] -> :five_of_a_kind
      [1, 2, {:joker, 2}] -> :four_of_a_kind
      [1, 1, 1, {:joker, 2}] -> :three_of_a_kind
      [4, {:joker, 1}] -> :five_of_a_kind
      [1, 3, {:joker, 1}] -> :four_of_a_kind
      [2, 2, {:joker, 1}] -> :full_house
      [1, 1, 2, {:joker, 1}] -> :three_of_a_kind
      [1, 1, 1, 1, {:joker, 1}] -> :one_pair
    end
  end

  defp rankable_type(:high_card), do: 1
  defp rankable_type(:one_pair), do: 2
  defp rankable_type(:two_pairs), do: 3
  defp rankable_type(:three_of_a_kind), do: 4
  defp rankable_type(:full_house), do: 5
  defp rankable_type(:four_of_a_kind), do: 6
  defp rankable_type(:five_of_a_kind), do: 7

  defp parse(input, rule) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line(&1, rule))
  end

  defp parse_line(line, rule) do
    [cards, bid] = line |> String.split(" ")

    %{
      cards: parse_cards(cards, rule),
      bid: String.to_integer(bid)
    }
  end

  defp parse_cards(cards, rule) do
    cards
    |> String.split("", trim: true)
    |> Enum.map(&parse_card(&1, rule))
  end

  defp parse_card("2", _), do: 2
  defp parse_card("3", _), do: 3
  defp parse_card("4", _), do: 4
  defp parse_card("5", _), do: 5
  defp parse_card("6", _), do: 6
  defp parse_card("7", _), do: 7
  defp parse_card("8", _), do: 8
  defp parse_card("9", _), do: 9
  defp parse_card("T", _), do: 10
  defp parse_card("J", :joker), do: 1
  defp parse_card("J", :no_joker), do: 11
  defp parse_card("Q", _), do: 12
  defp parse_card("K", _), do: 13
  defp parse_card("A", _), do: 14
end
