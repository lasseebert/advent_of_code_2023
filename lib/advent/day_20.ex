defmodule Advent.Day20 do
  @moduledoc """
  Day 20
  """

  @doc """
  Part 1
  """
  @spec part_1(String.t()) :: integer
  def part_1(input) do
    modules = input |> parse()
    states = init_state(modules)
    sent = %{}

    {_states, sent} =
      1..1000
      |> Enum.reduce({states, sent}, fn _, {states, sent} ->
        run([{:button, :broadcaster, :low}], states, sent, modules)
      end)

    sent
    |> Map.values()
    |> Enum.reduce(fn counts_1, counts_2 ->
      Map.merge(counts_1, counts_2, fn _, count_1, count_2 -> count_1 + count_2 end)
    end)
    |> Map.values()
    |> Enum.product()
  end

  @doc """
  Part 2

  Layer 2
  &cl -> rx

  Layer 3
  &js -> cl
  &qs -> cl
  &dt -> cl
  &ts -> cl

  * we need rx to be low
  * So cl should receive all high signals
  * So all js, qs, dt, ts (which only have one input each) should receive low signals
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    modules = input |> parse()
    states = init_state(modules)

    layer_1 = ["rx"]
    layer_2 = layer_1 |> Enum.flat_map(&children(&1, modules))
    layer_3 = layer_2 |> Enum.flat_map(&children(&1, modules))

    states
    |> Stream.unfold(fn states ->
      {states, sent} = run([{:button, :broadcaster, :low}], states, %{}, modules)
      {{states, sent}, states}
    end)
    |> Stream.with_index()
    |> Enum.reduce_while(%{}, fn {{_states, sent}, index}, cycles ->
      cycles =
        Enum.reduce(layer_3, cycles, fn name, cycles ->
          sent_low = Map.get(sent, name, %{}) |> Map.get(:low, 0) > 0

          if sent_low do
            Map.update(cycles, name, [index], fn
              [prev_index] -> [prev_index, index]
              [i1, i2] -> [i1, i2]
            end)
          else
            cycles
          end
        end)

      # We're done when we hit low for all layer 3 nodes twice
      if Enum.count(cycles) == length(layer_3) and
           cycles |> Map.values() |> Enum.all?(fn indices -> length(indices) == 2 end) do
        {:halt, cycles}
      else
        {:cont, cycles}
      end
    end)
    |> Enum.map(fn {_name, [i1, i2]} -> {i1, i2 - i1} end)
    |> Enum.reduce(&combine_cycles/2)
    |> then(fn {_offset, length} -> length end)
  end

  # Combines two cycles into a single cycle
  # Stolen from https://math.stackexchange.com/a/3864593
  defp combine_cycles({offset_1, length_1}, {offset_2, length_2}) do
    {gcd, s, _t} = extended_gcd(length_1, length_2)
    offset_diff = offset_1 - offset_2

    pd_mult = div(offset_diff, gcd)
    pd_remainder = rem(offset_diff, gcd)

    if pd_remainder != 0 do
      raise "Cycles never synchronize"
    end

    combined_length = div(length_1, gcd) * length_2
    combined_offset = rem(offset_1 - s * pd_mult * length_1, combined_length)

    {combined_offset, combined_length}
  end

  # Extended Euclidean algorithm
  # Returns:
  #   d = gcd(a, b)
  #   s and t so that gcd(a, b) = sa + tb
  defp extended_gcd(a, b) do
    case b do
      0 ->
        {a, 1, 0}

      _ ->
        {d, s, t} = extended_gcd(b, rem(a, b))
        {d, t, s - div(a, b) * t}
    end
  end

  defp children(name, modules) do
    modules
    |> Enum.filter(fn {_, {_, outputs}} -> Enum.member?(outputs, name) end)
    |> Enum.map(fn {child_name, _} -> child_name end)
  end

  defp run([], states, sent, _modules) do
    {states, sent}
  end

  defp run([{sender, receiver, signal} | signals], states, sent, modules) do
    {states, sent, new_signals} = process_signal(signal, sender, receiver, states, sent, modules)
    run(signals ++ new_signals, states, sent, modules)
  end

  defp process_signal(signal, sender, receiver, states, sent, modules) do
    sent =
      Map.update(sent, receiver, %{signal => 1}, fn map ->
        Map.update(map, signal, 1, &(&1 + 1))
      end)

    with {:ok, state} <- Map.fetch(states, receiver),
         {type, outputs} <- Map.fetch!(modules, receiver) do
      {state, new_signals} = process_signal_type(type, sender, receiver, signal, state, outputs)
      states = Map.put(states, receiver, state)
      {states, sent, new_signals}
    else
      :error ->
        {states, sent, []}
    end
  end

  defp process_signal_type(:broadcaster, _sender, receiver, signal, state, outputs) do
    {state, Enum.map(outputs, fn output -> {receiver, output, signal} end)}
  end

  defp process_signal_type(:flip_flop, _sender, _receiver, :high, state, _outputs), do: {state, []}

  defp process_signal_type(:flip_flop, _sender, receiver, :low, state, outputs) do
    state = !state

    signal =
      case state do
        true -> :high
        false -> :low
      end

    {state, Enum.map(outputs, fn output -> {receiver, output, signal} end)}
  end

  defp process_signal_type(:conjunction, sender, receiver, signal, state, outputs) do
    state = Map.put(state, sender, signal)

    signal_out =
      state
      |> Enum.all?(fn {_, signal} -> signal == :high end)
      |> case do
        true -> :low
        false -> :high
      end

    {state, Enum.map(outputs, fn output -> {receiver, output, signal_out} end)}
  end

  defp init_state(modules) do
    outputs = modules |> Enum.into(%{}, fn {name, {_type, outputs}} -> {name, outputs} end)

    inputs =
      outputs
      |> Enum.flat_map(fn {name, outputs} ->
        Enum.map(outputs, fn output -> {output, name} end)
      end)
      |> Enum.reduce(%{}, fn {name, input}, acc ->
        Map.update(acc, name, [input], &[input | &1])
      end)

    modules
    |> Enum.map(fn {name, {type, _outputs}} ->
      case type do
        :button -> {name, nil}
        :broadcaster -> {name, nil}
        :flip_flop -> {name, false}
        :conjunction -> {name, inputs |> Map.fetch!(name) |> Enum.into(%{}, &{&1, false})}
      end
    end)
    |> Enum.into(%{})
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_module/1)
    |> Enum.into(%{})
  end

  defp parse_module(line) do
    line
    |> String.split(" -> ")
    |> then(fn [identifier, outputs] ->
      {name, type} =
        case identifier do
          "broadcaster" -> {:broadcaster, :broadcaster}
          "%" <> name -> {name, :flip_flop}
          "&" <> name -> {name, :conjunction}
        end

      outputs = outputs |> String.split(", ")

      {name, {type, outputs}}
    end)
  end
end
