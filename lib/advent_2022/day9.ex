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
    |> Enum.reduce([{0, 0}], &process/2)
    |> Enum.scan({0, 0}, &make_adjacent/2)
    |> Enum.uniq()
    |> Enum.count()
  end

  @doc ~S"""
    iex> part2("R 4
    ...>        U 4
    ...>        L 3
    ...>        D 1
    ...>        R 4
    ...>        D 1
    ...>        L 5
    ...>        R 2")
    1
    iex> part2("R 5
    ...>        U 8
    ...>        L 8
    ...>        D 3
    ...>        R 17
    ...>        D 10
    ...>        L 25
    ...>        U 20")
    36

    iex> Advent2022.load_data(9) |> part2()
    2566
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> prepare_input()
    # H
    |> Enum.reduce([{0, 0}], &process/2)
    # 1
    |> Enum.scan({0, 0}, &make_adjacent/2)
    # 2
    |> Enum.scan({0, 0}, &make_adjacent/2)
    # 3
    |> Enum.scan({0, 0}, &make_adjacent/2)
    # 4
    |> Enum.scan({0, 0}, &make_adjacent/2)
    # 5
    |> Enum.scan({0, 0}, &make_adjacent/2)
    # 6
    |> Enum.scan({0, 0}, &make_adjacent/2)
    # 7
    |> Enum.scan({0, 0}, &make_adjacent/2)
    # 8
    |> Enum.scan({0, 0}, &make_adjacent/2)
    # 9
    |> Enum.scan({0, 0}, &make_adjacent/2)
    |> Enum.uniq()
    |> Enum.count()
  end

  @spec prepare_input(String.t()) :: [[String.t()]]
  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&(String.trim(&1) |> String.split(" ", trim: true)))
    |> Enum.map(fn [dir, len] -> [dir, String.to_integer(len)] end)
  end

  @spec process([String.t()], [point()]) :: [point()]
  defp process(["U", len], so_far),
    do:
      1..len |> Enum.reduce(so_far, fn _, acc -> acc ++ [add_points({0, 1}, List.last(acc))] end)

  defp process(["D", len], so_far),
    do:
      1..len |> Enum.reduce(so_far, fn _, acc -> acc ++ [add_points({0, -1}, List.last(acc))] end)

  defp process(["L", len], so_far),
    do:
      1..len |> Enum.reduce(so_far, fn _, acc -> acc ++ [add_points({-1, 0}, List.last(acc))] end)

  defp process(["R", len], so_far),
    do:
      1..len |> Enum.reduce(so_far, fn _, acc -> acc ++ [add_points({1, 0}, List.last(acc))] end)

  @spec add_points(point(), point()) :: point()
  defp add_points({x, y}, {a, b}), do: {x + a, y + b}

  @spec make_adjacent(point(), point()) :: point()
  defp make_adjacent({x, y}, {a, b}) when abs(x - a) <= 1 and abs(y - b) <= 1, do: {a, b}

  defp make_adjacent({x, y}, {a, b}) do
    diff_x = x - a
    diff_y = y - b
    diff_x_dir = if diff_x > 0, do: 1, else: -1
    diff_y_dir = if diff_y > 0, do: 1, else: -1

    cond do
      diff_x == 0 && diff_y == 0 -> {a, b}
      diff_x == 0 -> {a, b + diff_y_dir}
      diff_y == 0 -> {a + diff_x_dir, b}
      true -> {a + diff_x_dir, b + diff_y_dir}
    end
  end
end
