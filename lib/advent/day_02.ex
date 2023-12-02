defmodule Advent.Day02 do
  @moduledoc """
  Day 02
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    games = input |> parse()

    max = %{
      red: 12,
      green: 13,
      blue: 14
    }

    games
    |> Enum.filter(fn {_id, game} ->
      for(round <- game, {color, max_amount} <- max, do: {round, color, max_amount})
      |> Enum.all?(fn {round, color, max_amount} -> Map.get(round, color, 0) <= max_amount end)
    end)
    |> Enum.map(fn {id, _game} -> id end)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> Enum.map(fn {_id, game} -> game end)
    |> Enum.map(&power/1)
    |> Enum.sum()
  end

  defp power(game) do
    game
    |> Enum.reduce(%{}, &Map.merge(&1, &2, fn _k, v1, v2 -> max(v1, v2) end))
    |> Map.values()
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [id_text, game_text] = line |> String.split(": ")
    {parse_id(id_text), parse_game(game_text)}
  end

  defp parse_id("Game " <> id_string), do: String.to_integer(id_string)

  defp parse_game(game_text) do
    game_text
    |> String.split("; ")
    |> Enum.map(&parse_round/1)
  end

  defp parse_round(round_text) do
    round_text
    |> String.split(", ")
    |> Enum.map(&parse_color/1)
    |> Map.new()
  end

  defp parse_color(color_text) do
    color_text
    |> String.split(" ")
    |> then(fn [amount, color] ->
      amount = String.to_integer(amount)

      color =
        case color do
          "red" -> :red
          "blue" -> :blue
          "green" -> :green
        end

      {color, amount}
    end)
  end
end
