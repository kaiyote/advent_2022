defmodule Advent2022.Day3 do
  @moduledoc false

  @doc ~S"""
    iex> part1("vJrwpWtwJgWrhcsFMMfFFhFp
    ...>        jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    ...>        PmmdzqPrVvPwwTWBwg
    ...>        wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ...>        ttgJtRGJQctTZtZT
    ...>        CrZsJsPPZsGzwwsLwLmpwMDw")
    157

    iex> Advent2022.load_data(3) |> part1()
    7785
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.map(&String.split_at(&1, div(String.length(&1), 2)))
    |> Enum.map(&item_in_both/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  @doc ~S"""
    iex> part2("vJrwpWtwJgWrhcsFMMfFFhFp
    ...>        jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    ...>        PmmdzqPrVvPwwTWBwg
    ...>        wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ...>        ttgJtRGJQctTZtZT
    ...>        CrZsJsPPZsGzwwsLwLmpwMDw")
    70

    iex> Advent2022.load_data(3) |> part2()
    2633
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    |> Enum.chunk_every(3)
    |> Enum.map(&item_in_all/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  @spec prepare_input(String.t()) :: any()
  defp prepare_input(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&String.trim/1)
  end

  @spec item_in_both({String.t(), String.t()}) :: String.t()
  defp item_in_both({first, second}) do
    first
    |> String.split("", trim: true)
    |> Enum.reject(fn c -> not (second |> String.split("", trim: true) |> Enum.member?(c)) end)
    |> Enum.at(0)
  end

  @spec item_in_all([String.t()]) :: String.t()
  defp item_in_all([elf_1, elf_2, elf_3]) do
    elf_1_chunks = elf_1 |> String.split("", trim: true)
    elf_2_chunks = elf_2 |> String.split("", trim: true)
    elf_3_chunks = elf_3 |> String.split("", trim: true)

    elf_1_chunks
    |> Enum.reject(fn c ->
      not Enum.member?(elf_2_chunks, c) or not Enum.member?(elf_3_chunks, c)
    end)
    |> Enum.at(0)
  end

  @spec priority(String.t()) :: integer()
  defp priority("a"), do: 1
  defp priority("b"), do: 2
  defp priority("c"), do: 3
  defp priority("d"), do: 4
  defp priority("e"), do: 5
  defp priority("f"), do: 6
  defp priority("g"), do: 7
  defp priority("h"), do: 8
  defp priority("i"), do: 9
  defp priority("j"), do: 10
  defp priority("k"), do: 11
  defp priority("l"), do: 12
  defp priority("m"), do: 13
  defp priority("n"), do: 14
  defp priority("o"), do: 15
  defp priority("p"), do: 16
  defp priority("q"), do: 17
  defp priority("r"), do: 18
  defp priority("s"), do: 19
  defp priority("t"), do: 20
  defp priority("u"), do: 21
  defp priority("v"), do: 22
  defp priority("w"), do: 23
  defp priority("x"), do: 24
  defp priority("y"), do: 25
  defp priority("z"), do: 26
  defp priority("A"), do: 27
  defp priority("B"), do: 28
  defp priority("C"), do: 29
  defp priority("D"), do: 30
  defp priority("E"), do: 31
  defp priority("F"), do: 32
  defp priority("G"), do: 33
  defp priority("H"), do: 34
  defp priority("I"), do: 35
  defp priority("J"), do: 36
  defp priority("K"), do: 37
  defp priority("L"), do: 38
  defp priority("M"), do: 39
  defp priority("N"), do: 40
  defp priority("O"), do: 41
  defp priority("P"), do: 42
  defp priority("Q"), do: 43
  defp priority("R"), do: 44
  defp priority("S"), do: 45
  defp priority("T"), do: 46
  defp priority("U"), do: 47
  defp priority("V"), do: 48
  defp priority("W"), do: 49
  defp priority("X"), do: 50
  defp priority("Y"), do: 51
  defp priority("Z"), do: 52
end
