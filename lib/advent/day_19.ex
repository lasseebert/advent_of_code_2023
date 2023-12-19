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
    {workflows, _parts} = input |> parse()

    parts = [{%{x: 1..4000, m: 1..4000, a: 1..4000, s: 1..4000}, {"in", 0}}]
    accepted_parts = []

    parts
    |> find_accepted(workflows, accepted_parts)
    |> Enum.map(&part_combinations/1)
    |> Enum.sum()
  end

  defp part_combinations(part) do
    part
    |> Map.values()
    |> Enum.map(&Enum.count/1)
    |> Enum.product()
  end

  defp find_accepted([], _workflows, accepted_parts), do: accepted_parts

  defp find_accepted([{part, {workflow_name, rule_index}} | parts], workflows, accepted_parts) do
    {expression, target} = workflows |> Map.fetch!(workflow_name) |> Enum.at(rule_index)

    {parts, accepted_parts} =
      part
      |> split_by_expression(expression)
      |> then(fn [pass, fail] ->
        # Add passed part of part to parts or accepted_parts
        {parts, accepted_parts} =
          if part_combinations(pass) > 0 do
            case target do
              :accept -> {parts, [pass | accepted_parts]}
              :reject -> {parts, accepted_parts}
              {:workflow, name} -> {[{pass, {name, 0}} | parts], accepted_parts}
            end
          else
            {parts, accepted_parts}
          end

        # Retry failed part of part with next rule in same workflow
        parts =
          if part_combinations(fail) > 0 do
            [{fail, {workflow_name, rule_index + 1}} | parts]
          else
            parts
          end

        {parts, accepted_parts}
      end)

    find_accepted(parts, workflows, accepted_parts)
  end

  # Split a part range into passed and failed part ranges based on the expression
  defp split_by_expression(part, {op, {var, value}}) do
    {pass, fail} =
      part
      |> Map.fetch!(var)
      |> split_range(op, value)

    [
      Map.merge(part, %{var => pass}),
      Map.merge(part, %{var => fail})
    ]
  end

  defp split_by_expression(part, true) do
    [
      part,
      # This just means an empty part range
      Map.put(part, :x, 1..0//1)
    ]
  end

  # Split a numeric range into two parts based on a comparison operator and a value
  defp split_range(%{first: first} = range, :lt, value) do
    Range.split(range, Enum.max([value - first, 0]))
  end

  defp split_range(range, :gt, value) do
    range
    |> split_range(:lt, value + 1)
    |> then(fn {fail, pass} -> {pass, fail} end)
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
