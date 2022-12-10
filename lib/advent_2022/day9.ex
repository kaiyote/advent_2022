defmodule Advent2022.Day9 do
  @moduledoc false

  @type point :: {integer(), integer()}

  @doc ~S"""
    iex> part1("R 4
    ...>        U 4
    ...>        L 3
    ...>        D 1
    ...>        R 4
    ...>        D 1
    ...>        L 5
    ...>        R 2")
    13

    iex> Advent2022.load_data(9) |> part1()
    6090
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.reduce({[{0, 0}], [{0, 0}]}, fn move, acc -> process(move, acc) end)
    |> elem(1)
    |> Enum.uniq()
    |> Enum.count()
  end

  @doc ~S"""
    iex> part2("")
    0
  """
  @spec part2(String.t()) :: integer()
  def part2(_input) do
    0
  end

  @spec prepare_input(String.t()) :: any()
  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&(String.trim(&1) |> String.split(" ", trim: true)))
    |> Enum.map(fn [dir, len] -> [dir, String.to_integer(len)] end)
  end

  @spec process([String.t()], {[point()], [point()]}) :: {[point()], [point()]}
  defp process(["U", len], {head, tail}),
    do: 1..len |> Enum.reduce({head, tail}, fn _, acc -> move({0, 1}, acc) end)

  defp process(["L", len], {head, tail}),
    do: 1..len |> Enum.reduce({head, tail}, fn _, acc -> move({-1, 0}, acc) end)

  defp process(["D", len], {head, tail}),
    do: 1..len |> Enum.reduce({head, tail}, fn _, acc -> move({0, -1}, acc) end)

  defp process(["R", len], {head, tail}),
    do: 1..len |> Enum.reduce({head, tail}, fn _, acc -> move({1, 0}, acc) end)

  @spec move({1 | 0 | -1, 1 | 0 | -1}, {[point()], [point()]}) :: {[point()], [point()]}
  defp move({x, y}, {head, tail}) do
    new_head = add_points(List.last(head), {x, y})
    head = head ++ [new_head]

    tail =
      if adjacent?(new_head, List.last(tail)),
        do: tail,
        else: tail ++ [make_adjacent(new_head, List.last(tail))]

    {head, tail}
  end

  @spec add_points(point(), point()) :: point()
  defp add_points({x, y}, {a, b}), do: {x + a, y + b}

  @spec adjacent?(point(), point()) :: boolean()
  defp adjacent?({x, y}, {a, b}), do: abs(x - a) <= 1 and abs(y - b) <= 1

  @spec make_adjacent(point(), point()) :: point()
  defp make_adjacent({x, y}, {a, b}) do
    diff_x = x - a
    diff_y = y - b

    cond do
      diff_x == 0 -> {a, b + if(diff_y > 0, do: 1, else: -1)}
      diff_y == 0 -> {a + if(diff_x > 0, do: 1, else: -1), b}
      true -> {a + if(diff_x > 0, do: 1, else: -1), b + if(diff_y > 0, do: 1, else: -1)}
    end
  end
end
