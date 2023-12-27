defmodule Advent.Matrix do
  @moduledoc """
  Asorted matrix calculations
  """

  @type t :: [[number]]

  @doc """
  Creates a new Matrix from a list of lists
  """
  @spec new([[number]]) :: t
  def new(matrix) do
    matrix
  end

  # Determinant of an nxn matrix
  @spec det(t) :: number
  def det(matrix) do
    if Enum.count(matrix) == 1 do
      matrix |> Enum.at(0) |> Enum.at(0)
    else
      0..(length(matrix) - 1)
      |> Enum.map(fn index ->
        top = matrix |> hd() |> Enum.at(index)
        minor = minor(matrix, 0, index)
        factor = if rem(index, 2) == 0, do: 1, else: -1

        factor * top * det(minor)
      end)
      |> Enum.sum()
    end
  end

  @spec replace_column(t, integer, [number]) :: t
  def replace_column(matrix, column_index, column) do
    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      List.replace_at(row, column_index, Enum.at(column, row_index))
    end)
  end

  defp minor(matrix, row_index, column_index) do
    matrix
    |> Enum.with_index()
    |> Enum.reject(fn {_, index} -> index == row_index end)
    |> Enum.map(fn {row, _} ->
      row
      |> Enum.with_index()
      |> Enum.reject(fn {_, index} -> index == column_index end)
      |> Enum.map(fn {value, _} -> value end)
    end)
  end
end
