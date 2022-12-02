defmodule Advent2022.Day2 do
  @moduledoc false

  @doc ~S"""
    iex> part1("A Y
    ...>        B X
    ...>        C Z")
    15

    iex> Advent2022.load_data(2) |> part1()
    11906
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.map(&(round_score(&1)))
    |> Enum.sum()
  end

  @doc ~S"""
    iex> part2("A Y
    ...>        B X
    ...>        C Z")
    12

    iex> Advent2022.load_data(2) |> part2()
    11186
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    |> Enum.map(fn ([them, you]) -> [them, win_to_move(them, you)] end)
    |> Enum.map(&(round_score(&1)))
    |> Enum.sum()
  end

  @spec prepare_input(String.t()) :: [[String.t()]]
  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/\s+/, trim: true)
    |> Enum.chunk_every(2)
  end

  defp round_score([them, you]), do: win_score(them, you) + move_score(you)

  defp move_score("X"), do: 1
  defp move_score("Y"), do: 2
  defp move_score("Z"), do: 3

  defp win_score("A", "Y"), do: 6
  defp win_score("B", "Z"), do: 6
  defp win_score("C", "X"), do: 6
  defp win_score("A", "X"), do: 3
  defp win_score("B", "Y"), do: 3
  defp win_score("C", "Z"), do: 3
  defp win_score(_, _), do: 0

  defp win_to_move("A", you) do
    case you do
      "X" -> "Z"
      "Y" -> "X"
      _ -> "Y"
    end
  end
  defp win_to_move("B", you) do
    case you do
      "X" -> "X"
      "Y" -> "Y"
      _ -> "Z"
    end
  end
  defp win_to_move("C", you) do
    case you do
      "X" -> "Y"
      "Y" -> "Z"
      _ -> "X"
    end
  end
end
