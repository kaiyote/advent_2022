defmodule Advent2022.Day1 do
  @moduledoc false

  @doc ~S"""
    iex> part1("1000
    ...>        2000
    ...>        3000
    ...>
    ...>        4000
    ...>
    ...>        5000
    ...>        6000
    ...>
    ...>        7000
    ...>        8000
    ...>        9000
    ...>
    ...>        10000")
    24000

    iex> Advent2022.load_data(1) |> part1()
    69528
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.max()
  end

  @doc ~S"""
    iex> part2("1000
    ...>        2000
    ...>        3000
    ...>
    ...>        4000
    ...>
    ...>        5000
    ...>        6000
    ...>
    ...>        7000
    ...>        8000
    ...>        9000
    ...>
    ...>        10000")
    45000

    iex> Advent2022.load_data(1) |> part2()
    206152
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    |> Enum.sort(&(&1 >= &2))
    |> Enum.take(3)
    |> Enum.sum()
  end

  @spec prepare_input(String.t()) :: [integer()]
  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/\n\n/, trim: true)
    |> Enum.map(&(&1 |> String.trim() |> String.split(~r/\n/, trim: true)))
    |> Enum.map(
      &(&1
        |> Enum.map(fn s -> s |> String.trim() |> String.to_integer() end)
        |> Enum.sum())
    )
  end
end
