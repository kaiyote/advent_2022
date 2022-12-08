defmodule Advent2022.Day8 do
  @moduledoc false

  @doc ~S"""
    iex> part1("30373
    ...>        25512
    ...>        65332
    ...>        33549
    ...>        35390")
    21

    iex> Advent2022.load_data(8) |> part1()
    1546
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    [rows, columns] = prepare_input(input)

    for y <- 0..(Enum.count(rows) - 1) do
      for x <- 0..(Enum.count(columns) - 1) do
        is_edge(x, y, rows, columns) or is_visible(x, y, rows, columns)
      end
    end
    |> Enum.flat_map(&Enum.map(&1, fn s -> s end))
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  @doc ~S"""
    iex> part2("30373
    ...>        25512
    ...>        65332
    ...>        33549
    ...>        35390")
    8

    iex> Advent2022.load_data(8) |> part2()
    519064
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    [rows, columns] = prepare_input(input)

    for y <- 0..(Enum.count(rows) - 1) do
      for x <- 0..(Enum.count(columns) - 1) do
        scenic_score(x, y, rows, columns)
      end
    end
    |> Enum.flat_map(&Enum.map(&1, fn s -> s end))
    |> Enum.max()
  end

  @spec prepare_input(String.t()) :: [[[integer()]]]
  defp prepare_input(input) do
    horizontal =
      input
      |> String.trim()
      |> String.split(~r/\n/, trim: true)
      |> Enum.map(
        &(String.trim(&1)
          |> String.split("", trim: true)
          |> Enum.map(fn s -> String.to_integer(s) end))
      )

    [horizontal, transpose(horizontal)]
  end

  @spec transpose([[any()]]) :: [[any()]]
  defp transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @spec is_edge(integer(), integer(), [[integer()]], [[integer()]]) :: boolean()
  defp is_edge(x, y, rows, columns),
    do: x == 0 or y == 0 or y == Enum.count(rows) - 1 or x == Enum.count(columns) - 1

  @spec is_visible(integer(), integer(), [[integer()]], [[integer()]]) :: boolean()
  defp is_visible(x, y, rows, columns) do
    value = rows |> Enum.at(y) |> Enum.at(x)

    visible_from_left(value, x, y, rows) or visible_from_left(value, y, x, columns) or
      visible_from_right(value, x, y, rows) or visible_from_right(value, y, x, columns)
  end

  @spec visible_from_left(integer(), integer(), integer(), [[integer()]]) :: boolean()
  defp visible_from_left(value, x, y, rows) do
    rows
    |> Enum.at(y)
    |> Enum.take(x)
    |> Enum.all?(fn n -> n < value end)
  end

  @spec visible_from_right(integer(), integer(), integer(), [[integer()]]) :: boolean()
  defp visible_from_right(value, x, y, rows) do
    rows
    |> Enum.at(y)
    |> Enum.drop(x + 1)
    |> Enum.all?(fn n -> n < value end)
  end

  @spec scenic_score(integer(), integer(), [[integer()]], [[integer()]]) :: integer()
  defp scenic_score(x, y, rows, columns) do
    if is_edge(x, y, rows, columns) do
      0
    else
      value = rows |> Enum.at(y) |> Enum.at(x)

      left_visible_from(value, x, y, rows) * left_visible_from(value, y, x, columns) *
        right_visible_from(value, x, y, rows) * right_visible_from(value, y, x, columns)
    end
  end

  @spec left_visible_from(integer(), integer(), integer(), [[integer()]]) :: integer()
  defp left_visible_from(value, x, y, rows) do
    possible =
      rows
      |> Enum.at(y)
      |> Enum.take(x)
      |> Enum.reverse()

    max_count = Enum.count(possible)

    possible
    |> Enum.take_while(fn s -> s < value end)
    |> Enum.count()
    |> (&Enum.min([&1 + 1, max_count])).()
  end

  @spec right_visible_from(integer(), integer(), integer(), [[integer()]]) :: integer()
  defp right_visible_from(value, x, y, rows) do
    possible =
      rows
      |> Enum.at(y)
      |> Enum.drop(x + 1)

    max_count = Enum.count(possible)

    possible
    |> Enum.take_while(fn s -> s < value end)
    |> Enum.count()
    |> (&Enum.min([&1 + 1, max_count])).()
  end
end
