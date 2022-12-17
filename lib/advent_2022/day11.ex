defmodule Advent2022.Day11 do
  @moduledoc false

  @type monkey :: {[integer()], (integer() -> integer()), (integer() -> integer())}

  @doc ~S"""
    iex> part1("Monkey 0:
    ...>          Starting items: 79, 98
    ...>          Operation: new = old * 19
    ...>          Test: divisible by 23
    ...>            If true: throw to monkey 2
    ...>            If false: throw to monkey 3
    ...>
    ...>        Monkey 1:
    ...>          Starting items: 54, 65, 75, 74
    ...>          Operation: new = old + 6
    ...>          Test: divisible by 19
    ...>            If true: throw to monkey 2
    ...>            If false: throw to monkey 0
    ...>
    ...>        Monkey 2:
    ...>          Starting items: 79, 60, 97
    ...>          Operation: new = old * old
    ...>          Test: divisible by 13
    ...>            If true: throw to monkey 1
    ...>            If false: throw to monkey 3
    ...>
    ...>        Monkey 3:
    ...>          Starting items: 74
    ...>          Operation: new = old + 3
    ...>          Test: divisible by 17
    ...>            If true: throw to monkey 0
    ...>            If false: throw to monkey 1")
    10605

    iex> Advent2022.load_data(11) |> part1()
    110220
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    monkeys = input |> prepare_input() |> Enum.with_index()

    1..20
    |> Enum.reduce({monkeys, %{}}, fn _, acc -> process_round(acc) end)
    |> elem(1)
    |> Map.values()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(2)
    |> (&(Enum.at(&1, 0) * Enum.at(&1, 1))).()
  end

  @doc ~S"""
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    monkeys = input |> prepare_input(false) |> Enum.with_index()

    1..1000
    |> Enum.reduce({monkeys, %{}}, fn _, acc -> process_round(acc) end)
    |> elem(1)
    |> Map.values()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(2)
    |> (&(Enum.at(&1, 0) * Enum.at(&1, 1))).()
  end

  @spec prepare_input(String.t(), boolean()) :: [monkey()]
  defp prepare_input(input, div_three \\ true) do
    input
    |> String.trim()
    |> String.split(~r/\n\n/, trim: true)
    |> Enum.map(&parse_monkey(&1, div_three))
  end

  @spec process_round({[{monkey(), integer()}], %{integer() => integer()}}) :: {[{monkey(), integer()}], %{integer() => integer()}}
  defp process_round({monkeys, inspect_counter}) do
    0..(Enum.count(monkeys) - 1)
    |> Enum.reduce({monkeys, inspect_counter}, fn i, {acc, acc_counter} -> process_monkey(Enum.at(acc, i), {acc, acc_counter}) end)
  end

  @spec process_monkey({monkey(), integer()}, {[{monkey(), integer()}], %{integer() => integer()}}) :: {[{monkey(), integer()}], %{integer() => integer()}}
  defp process_monkey({{items, opp, test}, index}, {monkies, inspect_counter}) do
    throws =
      items
      |> Enum.map(opp)
      |> Enum.reduce(%{}, fn i, acc -> Map.update(acc, test.(i), [i], fn exist -> exist ++ [i] end) end)

    {
      Enum.map(monkies, fn {{items, opp, test}, i} -> {{(if i == index, do: [], else: items ++ Map.get(throws, i, [])), opp, test}, i} end),
      Map.update(inspect_counter, index, Enum.count(items), fn ex -> ex + Enum.count(items) end)
    }
  end

  @spec parse_monkey(String.t(), boolean()) :: monkey()
  defp parse_monkey(chunk, div_three) do
    chunk
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.drop(1)
    |> make_monkey(div_three)
  end

  @spec make_monkey([String.t()], boolean()) :: monkey()
  defp make_monkey([start, opp | test], div_three) do
    {
      start |> String.split(":", trim: true) |> Enum.at(1) |> String.split(",", trim: true) |> Enum.map(&(String.trim(&1) |> String.to_integer())),
      monkey_op(opp, div_three),
      monkey_test(test)
    }
  end

  @spec monkey_op(String.t(), boolean()) :: (integer() -> integer())
  defp monkey_op(op, div_three) do
    code =
      op
      |> String.split(":", trim: true)
      |> Enum.at(1)
      |> String.trim()

    fn old ->
      {result, _} = Code.eval_string(code, [old: old], __ENV__)
      if div_three, do: floor(result / 3), else: result
    end
  end

  @spec monkey_test([String.t()]) :: (integer() -> integer())
  defp monkey_test(["Test: divisible by " <> divisor, "If true: throw to monkey " <> true_target, "If false: throw to monkey " <> false_target]) do
    fn test ->
      if Integer.mod(test, String.to_integer(divisor)) == 0, do: String.to_integer(true_target), else: String.to_integer(false_target)
    end
  end
end
