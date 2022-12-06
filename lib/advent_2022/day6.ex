defmodule Advent2022.Day6 do
  @moduledoc false

  @doc ~S"""
    iex> part1("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
    7
    iex> part1("bvwbjplbgvbhsrlpgdmjqwftvncz")
    5
    iex> part1("nppdvjthqldpwncqszvftbrmjlhg")
    6
    iex> part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
    10
    iex> part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
    11

    iex> Advent2022.load_data(6) |> part1()
    1623
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    process(input, 4)
  end

  @doc ~S"""
    iex> part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
    19
    iex> part2("bvwbjplbgvbhsrlpgdmjqwftvncz")
    23
    iex> part2("nppdvjthqldpwncqszvftbrmjlhg")
    23
    iex> part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
    29
    iex> part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
    26

    iex> Advent2022.load_data(6) |> part2()
    3774
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    process(input, 14)
  end

  @spec prepare_input(String.t(), integer()) :: [[String.t()]]
  defp prepare_input(input, len) do
    input
    |> String.split("", trim: true)
    |> Enum.chunk_every(len, 1)
  end

  defp process(input, len) do
    input
    |> prepare_input(len)
    |> Enum.find_index(fn (chunk) -> (chunk |> Enum.frequencies() |> Map.keys() |> Enum.count()) == len end)
    |> answer_len(len)
  end

  defp answer_len(index, len), do: index + len
end
