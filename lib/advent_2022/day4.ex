defmodule Advent2022.Day4 do
  @moduledoc false

  @doc ~S"""
    iex> part1("2-4,6-8
    ...>        2-3,4-5
    ...>        5-7,7-9
    ...>        2-8,3-7
    ...>        6-6,4-6
    ...>        2-6,4-8")
    2

    iex> Advent2022.load_data(4) |> part1()
    515
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.map(&contains?/1)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  @doc ~S"""
    iex> part2("2-4,6-8
    ...>        2-3,4-5
    ...>        5-7,7-9
    ...>        2-8,3-7
    ...>        6-6,4-6
    ...>        2-6,4-8")
    4

    iex> Advent2022.load_data(4) |> part2()
    883
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    |> Enum.map(fn [a, b] -> contains?([a, b]) or overlaps?([a, b]) end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  @spec prepare_input(String.t()) :: [[Range.t()]]
  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(
      &(&1
        |> String.trim()
        |> String.split(",", trim: true)
        |> Enum.map(fn elf ->
          elf
          |> String.split("-", trim: true)
          |> tuple_to_range()
        end))
    )
  end

  @spec contains?([Range.t()]) :: true | false
  defp contains?([range_a, range_b]) do
    (range_a.first >= range_b.first and range_a.last <= range_b.last) or
      (range_b.first >= range_a.first and range_b.last <= range_a.last)
  end

  @spec overlaps?([Range.t()]) :: true | false
  defp overlaps?([range_a, range_b]) do
    (range_a.first <= range_b.first and range_a.last >= range_b.first) or
      (range_a.first <= range_b.last and range_a.last >= range_b.last) or
      (range_b.first <= range_a.first and range_b.last >= range_a.first) or
      (range_b.first <= range_a.last and range_b.last >= range_a.last)
  end

  @spec tuple_to_range([String.t()]) :: Range.t()
  defp tuple_to_range([first, last]),
    do: Range.new(String.to_integer(first), String.to_integer(last))
end
