defmodule Advent2022.Day5 do
  @moduledoc false

  @doc ~S"""
    iex> part1("    [D]
    ...>[N] [C]
    ...>[Z] [M] [P]
    ...> 1   2   3
    ...>
    ...>move 1 from 2 to 1
    ...>move 3 from 1 to 3
    ...>move 2 from 2 to 1
    ...>move 1 from 1 to 2")
    "CMZ"

    iex> Advent2022.load_data(5) |> part1()
    "GFTNRBZPF"
  """
  @spec part1(String.t()) :: String.t()
  def part1(input) do
    [stacks, instructions] = prepare_input(input)

    instructions
    |> Enum.reduce(stacks, &process_instruction/2)
    |> Enum.map_join(&List.first/1)
  end

  @doc ~S"""
    iex> part2("    [D]
    ...>[N] [C]
    ...>[Z] [M] [P]
    ...> 1   2   3
    ...>
    ...>move 1 from 2 to 1
    ...>move 3 from 1 to 3
    ...>move 2 from 2 to 1
    ...>move 1 from 1 to 2")
    "MCD"

    iex> Advent2022.load_data(5) |> part2()
    "VRQWPDSGP"
  """
  @spec part2(String.t()) :: String.t()
  def part2(input) do
    [stacks, instructions] = prepare_input(input)

    instructions
    |> Enum.reduce(stacks, &process_instruction_upgraded/2)
    |> Enum.map_join(&List.first/1)
  end

  @spec prepare_input(String.t()) :: any()
  defp prepare_input(input) do
    [stacks, instructions] = input |> String.split(~r/\n\n/, trim: true)

    stacks =
      stacks
      |> String.split(~r/\n/)
      |> Enum.map(&(&1 |> String.split("")))

    target_len = stacks |> List.last() |> Enum.count()

    stacks =
      stacks
      |> Enum.map(&(&1 |> pad(target_len + 1)))
      |> transpose()
      |> Enum.filter(fn stack ->
        stack |> Enum.any?(fn c -> not (c == " " or c == "]" or c == "[" or c == "") end)
      end)
      |> Enum.map(&(&1 |> Enum.filter(fn c -> c |> String.match?(~r/[A-Z]/) end)))

    parsed_instructions =
      instructions
      |> String.split(~r/\n/, trim: true)
      |> Enum.map(
        &(&1
          |> String.trim()
          |> String.split(" ", trim: true)
          |> instruction_to_numbers())
      )

    [stacks, parsed_instructions]
  end

  @spec instruction_to_numbers([String.t()]) :: [integer()]
  defp instruction_to_numbers([_, count, _, source, _, target]),
    do: [count, source, target] |> Enum.map(fn n -> String.to_integer(n) end)

  @spec transpose([[any()]]) :: [[any()]]
  defp transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @spec pad([String.t()], integer()) :: [String.t()]
  defp pad(list, len) do
    if Enum.count(list) == len, do: list, else: pad(list ++ [""], len)
  end

  @spec process_instruction([integer()], [[String.t()]]) :: [[String.t()]]
  defp process_instruction([num, from, to], stacks),
    do: reorder_stacks([num, from, to], stacks, false)

  @spec process_instruction_upgraded([integer()], [[String.t()]]) :: [[String.t()]]
  defp process_instruction_upgraded([num, from, to], stacks),
    do: reorder_stacks([num, from, to], stacks, true)

  @spec reorder_stacks([integer()], [[String.t()]], true | false) :: [[String.t()]]
  defp reorder_stacks([num, from, to], stacks, upgraded) do
    # from and to are 1-indexed, gotta make em 0-indexed for this to work
    source = Enum.at(stacks, from - 1)
    target = Enum.at(stacks, to - 1)

    moving =
      Enum.take(source, num)
      |> maybe_reverse(not upgraded)

    source = Enum.drop(source, num)
    target = moving ++ target

    stacks
    |> List.replace_at(from - 1, source)
    |> List.replace_at(to - 1, target)
  end

  @spec maybe_reverse([any()], true | false) :: [any()]
  defp maybe_reverse(list, reverse), do: if(reverse, do: Enum.reverse(list), else: list)
end
