defmodule Advent.Day19 do
  @moduledoc """
  Day 19
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    {workflows, parts} = input |> parse()

    parts
    |> Enum.filter(&accept?(&1, workflows))
    |> Enum.map(&(&1 |> Map.values() |> Enum.sum()))
    |> Enum.sum()
  end

  defp accept?(part, workflows) do
    run_workflow(part, workflows, "in")
  end

  defp run_workflow(part, workflows, name) do
    workflows
    |> Map.fetch!(name)
    |> then(fn rules ->
      run_rules(part, rules, workflows)
    end)
  end

  defp run_rules(part, [{expression, target} | rules], workflows) do
    if run_expression(expression, part) do
      case target do
        :accept -> true
        :reject -> false
        {:workflow, name} -> run_workflow(part, workflows, name)
      end
    else
      run_rules(part, rules, workflows)
    end
  end

  defp run_expression({:lt, {var, value}}, part), do: Map.fetch!(part, var) < value
  defp run_expression({:gt, {var, value}}, part), do: Map.fetch!(part, var) > value
  defp run_expression(true, _part), do: true

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
    |> String.split("\n\n", trim: true)
    |> then(fn [workflows, parts] ->
      {
        parse_workflows(workflows),
        parse_parts(parts)
      }
    end)
  end

  defp parse_workflows(workflows) do
    workflows
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_workflow/1)
    |> Enum.into(%{})
  end

  def parse_workflow(line) do
    line
    |> String.split(["{", "}"], trim: true)
    |> then(fn [name, rules] ->
      {
        name,
        parse_rules(rules)
      }
    end)
  end

  defp parse_rules(line) do
    line
    |> String.split(",", trim: true)
    |> Enum.map(&parse_rule/1)
  end

  defp parse_rule(line) do
    line
    |> String.split(":", trim: true)
    |> then(fn
      [target] ->
        {
          true,
          parse_target(target)
        }

      [expression, target] ->
        {
          parse_expression(expression),
          parse_target(target)
        }
    end)
  end

  defp parse_expression(expression) do
    ~r/^([xmas])([<>])(\d+)$/
    |> Regex.run(expression, capture: :all_but_first)
    |> then(fn [var, op, value] ->
      {parse_op(op), {parse_var(var), String.to_integer(value)}}
    end)
  end

  defp parse_var("x"), do: :x
  defp parse_var("m"), do: :m
  defp parse_var("a"), do: :a
  defp parse_var("s"), do: :s

  defp parse_op("<"), do: :lt
  defp parse_op(">"), do: :gt

  defp parse_target("A"), do: :accept
  defp parse_target("R"), do: :reject
  defp parse_target(name), do: {:workflow, name}

  defp parse_parts(parts) do
    parts
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_part/1)
  end

  defp parse_part(line) do
    ~r/^\{x=(\d+),m=(\d+),a=(\d+),s=(\d+)\}$/
    |> Regex.run(line, capture: :all_but_first)
    |> then(fn [x, m, a, s] ->
      %{
        x: String.to_integer(x),
        m: String.to_integer(m),
        a: String.to_integer(a),
        s: String.to_integer(s)
      }
    end)
  end
end
