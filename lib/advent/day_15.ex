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
    |> split()
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    boxes = %{}

    input
    |> split()
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce(boxes, &apply_instruction/2)
    |> Enum.flat_map(fn {box_number, lenses} ->
      slots = length(lenses)

      lenses
      |> Enum.with_index()
      |> Enum.map(fn {{_label, focal_length}, index} ->
        [
          box_number + 1,
          slots - index,
          focal_length
        ]
        |> Enum.reduce(&Kernel.*/2)
      end)
    end)
    |> Enum.sum()
  end

  defp apply_instruction({:put, label, focal_length}, boxes) do
    box_number = hash(label)

    boxes
    |> Map.update(box_number, [{label, focal_length}], fn lenses ->
      lenses
      |> Enum.find_index(fn {lens_label, _} -> lens_label == label end)
      |> case do
        nil ->
          [{label, focal_length} | lenses]

        index ->
          List.update_at(lenses, index, fn {_, _} -> {label, focal_length} end)
      end
    end)
  end

  defp apply_instruction({:remove, label}, boxes) do
    box_number = hash(label)

    boxes
    |> Map.update(box_number, [], fn lenses ->
      lenses
      |> Enum.find_index(fn {lens_label, _} -> lens_label == label end)
      |> case do
        nil ->
          lenses

        index ->
          List.delete_at(lenses, index)
      end
    end)
  end

  defp parse_instruction(input) do
    ~r/([a-z]+)([=\-])([1-9])?/
    |> Regex.run(input, capture: :all_but_first)
    |> case do
      [label, "=", focal_length] ->
        {:put, label, String.to_integer(focal_length)}

      [label, "-"] ->
        {:remove, label}
    end
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

  defp split(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
  end
end
