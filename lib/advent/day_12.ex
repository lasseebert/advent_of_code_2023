defmodule Advent.Day12 do
  @moduledoc """
  Day 12
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    input
    |> parse()
    |> Enum.map(&count_combinations/1)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    input
    |> parse()
    |> expand_times_5()
    |> Enum.map(&count_combinations/1)
    |> Enum.sum()
  end

  defp expand_times_5(data) do
    data
    |> Enum.map(fn {conditions, groups} ->
      conditions =
        conditions
        |> List.duplicate(5)
        |> Enum.intersperse(:unknown)
        |> List.flatten()

      groups =
        groups
        |> List.duplicate(5)
        |> List.flatten()

      {conditions, groups}
    end)
  end

  defp count_combinations({conditions, groups}) do
    cache = %{}

    {count, _cache} = count(conditions, groups, cache)
    count
  end

  defp count([], [], cache), do: {1, cache}
  defp count([], _, cache), do: {0, cache}

  defp count(conditions, groups, cache) do
    key = {conditions, groups}

    case Map.fetch(cache, key) do
      {:ok, count} ->
        {count, cache}

      :error ->
        {count, cache} =
          cond do
            groups == [] ->
              if Enum.all?(conditions, &(&1 in [:good, :unknown])) do
                {1, cache}
              else
                {0, cache}
              end

            length(conditions) >= groups |> Enum.intersperse(1) |> Enum.sum() ->
              {count_1, cache} = count_begin(conditions, groups, cache)
              {count_2, cache} = count_wait(conditions, groups, cache)

              {count_1 + count_2, cache}

            true ->
              {0, cache}
          end

        cache = Map.put(cache, key, count)
        {count, cache}
    end
  end

  defp count_begin(conditions, [group | groups], cache) do
    {start, conditions} = Enum.split(conditions, group)
    {next, conditions} = Enum.split(conditions, 1)

    cond do
      Enum.any?(start, &(&1 == :good)) ->
        {0, cache}

      next == [] ->
        count(conditions, groups, cache)

      hd(next) == :damaged ->
        {0, cache}

      true ->
        count(conditions, groups, cache)
    end
  end

  defp count_wait(conditions, groups, cache) do
    [next | conditions] = conditions

    if next in [:good, :unknown] do
      count(conditions, groups, cache)
    else
      {0, cache}
    end
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [conditions, groups] = String.split(line, " ")

    {
      parse_conditions(conditions),
      parse_groups(groups)
    }
  end

  defp parse_conditions(conditions) do
    conditions
    |> String.graphemes()
    |> Enum.map(fn
      "#" -> :damaged
      "." -> :good
      "?" -> :unknown
    end)
  end

  defp parse_groups(groups) do
    groups
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
