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
    sent = %{low: 0, high: 0}

    {_states, sent} =
      1..1000
      |> Enum.reduce({states, sent}, fn _, {states, sent} ->
        run([{:button, :broadcaster, :low}], states, sent, modules)
      end)

    sent
    |> Map.values()
    |> Enum.product()
  end

  defp run([], states, sent, _modules) do
    {states, sent}
  end

  defp run([{sender, receiver, signal} | signals], states, sent, modules) do
    {states, sent, new_signals} = process_signal(signal, sender, receiver, states, sent, modules)
    run(signals ++ new_signals, states, sent, modules)
  end

  defp process_signal(signal, sender, receiver, states, sent, modules) do
    sent = Map.update!(sent, signal, &(&1 + 1))

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
