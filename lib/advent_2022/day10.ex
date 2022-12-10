defmodule Advent2022.Day10 do
  @moduledoc false

  @doc ~S"""
    iex> part1("addx 15
    ...>        addx -11
    ...>        addx 6
    ...>        addx -3
    ...>        addx 5
    ...>        addx -1
    ...>        addx -8
    ...>        addx 13
    ...>        addx 4
    ...>        noop
    ...>        addx -1
    ...>        addx 5
    ...>        addx -1
    ...>        addx 5
    ...>        addx -1
    ...>        addx 5
    ...>        addx -1
    ...>        addx 5
    ...>        addx -1
    ...>        addx -35
    ...>        addx 1
    ...>        addx 24
    ...>        addx -19
    ...>        addx 1
    ...>        addx 16
    ...>        addx -11
    ...>        noop
    ...>        noop
    ...>        addx 21
    ...>        addx -15
    ...>        noop
    ...>        noop
    ...>        addx -3
    ...>        addx 9
    ...>        addx 1
    ...>        addx -3
    ...>        addx 8
    ...>        addx 1
    ...>        addx 5
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx -36
    ...>        noop
    ...>        addx 1
    ...>        addx 7
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx 2
    ...>        addx 6
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx 1
    ...>        noop
    ...>        noop
    ...>        addx 7
    ...>        addx 1
    ...>        noop
    ...>        addx -13
    ...>        addx 13
    ...>        addx 7
    ...>        noop
    ...>        addx 1
    ...>        addx -33
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx 2
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx 8
    ...>        noop
    ...>        addx -1
    ...>        addx 2
    ...>        addx 1
    ...>        noop
    ...>        addx 17
    ...>        addx -9
    ...>        addx 1
    ...>        addx 1
    ...>        addx -3
    ...>        addx 11
    ...>        noop
    ...>        noop
    ...>        addx 1
    ...>        noop
    ...>        addx 1
    ...>        noop
    ...>        noop
    ...>        addx -13
    ...>        addx -19
    ...>        addx 1
    ...>        addx 3
    ...>        addx 26
    ...>        addx -30
    ...>        addx 12
    ...>        addx -1
    ...>        addx 3
    ...>        addx 1
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx -9
    ...>        addx 18
    ...>        addx 1
    ...>        addx 2
    ...>        noop
    ...>        noop
    ...>        addx 9
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx -1
    ...>        addx 2
    ...>        addx -37
    ...>        addx 1
    ...>        addx 3
    ...>        noop
    ...>        addx 15
    ...>        addx -21
    ...>        addx 22
    ...>        addx -6
    ...>        addx 1
    ...>        noop
    ...>        addx 2
    ...>        addx 1
    ...>        noop
    ...>        addx -10
    ...>        noop
    ...>        noop
    ...>        addx 20
    ...>        addx 1
    ...>        addx 2
    ...>        addx 2
    ...>        addx -6
    ...>        addx -11
    ...>        noop
    ...>        noop
    ...>        noop")
    13140

    iex> Advent2022.load_data(10) |> part1()
    13440
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> prepare_input()
    |> Enum.reduce([1], fn instruction, register_history ->
      register_history ++ process(instruction, List.last(register_history, 1))
    end)
    |> Enum.drop(19)
    |> Enum.take_every(40)
    |> signal_strength()
  end

  @spec signal_strength([integer()]) :: integer()
  defp signal_strength([a, b, c, d, e, f]), do: a * 20 + b * 60 + c * 100 + d * 140 + e * 180 + f * 220

  @doc ~S"""
    iex> part2("addx 15
    ...>        addx -11
    ...>        addx 6
    ...>        addx -3
    ...>        addx 5
    ...>        addx -1
    ...>        addx -8
    ...>        addx 13
    ...>        addx 4
    ...>        noop
    ...>        addx -1
    ...>        addx 5
    ...>        addx -1
    ...>        addx 5
    ...>        addx -1
    ...>        addx 5
    ...>        addx -1
    ...>        addx 5
    ...>        addx -1
    ...>        addx -35
    ...>        addx 1
    ...>        addx 24
    ...>        addx -19
    ...>        addx 1
    ...>        addx 16
    ...>        addx -11
    ...>        noop
    ...>        noop
    ...>        addx 21
    ...>        addx -15
    ...>        noop
    ...>        noop
    ...>        addx -3
    ...>        addx 9
    ...>        addx 1
    ...>        addx -3
    ...>        addx 8
    ...>        addx 1
    ...>        addx 5
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx -36
    ...>        noop
    ...>        addx 1
    ...>        addx 7
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx 2
    ...>        addx 6
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx 1
    ...>        noop
    ...>        noop
    ...>        addx 7
    ...>        addx 1
    ...>        noop
    ...>        addx -13
    ...>        addx 13
    ...>        addx 7
    ...>        noop
    ...>        addx 1
    ...>        addx -33
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx 2
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx 8
    ...>        noop
    ...>        addx -1
    ...>        addx 2
    ...>        addx 1
    ...>        noop
    ...>        addx 17
    ...>        addx -9
    ...>        addx 1
    ...>        addx 1
    ...>        addx -3
    ...>        addx 11
    ...>        noop
    ...>        noop
    ...>        addx 1
    ...>        noop
    ...>        addx 1
    ...>        noop
    ...>        noop
    ...>        addx -13
    ...>        addx -19
    ...>        addx 1
    ...>        addx 3
    ...>        addx 26
    ...>        addx -30
    ...>        addx 12
    ...>        addx -1
    ...>        addx 3
    ...>        addx 1
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx -9
    ...>        addx 18
    ...>        addx 1
    ...>        addx 2
    ...>        noop
    ...>        noop
    ...>        addx 9
    ...>        noop
    ...>        noop
    ...>        noop
    ...>        addx -1
    ...>        addx 2
    ...>        addx -37
    ...>        addx 1
    ...>        addx 3
    ...>        noop
    ...>        addx 15
    ...>        addx -21
    ...>        addx 22
    ...>        addx -6
    ...>        addx 1
    ...>        noop
    ...>        addx 2
    ...>        addx 1
    ...>        noop
    ...>        addx -10
    ...>        noop
    ...>        noop
    ...>        addx 20
    ...>        addx 1
    ...>        addx 2
    ...>        addx 2
    ...>        addx -6
    ...>        addx -11
    ...>        noop
    ...>        noop
    ...>        noop")
    ["##..##..##..##..##..##..##..##..##..##..",
     "###...###...###...###...###...###...###.",
     "####....####....####....####....####....",
     "#####.....#####.....#####.....#####.....",
     "######......######......######......####",
     "#######.......#######.......#######....."]

    iex> Advent2022.load_data(10) |> part2()
    [
      "###..###..####..##..###...##..####..##..",
      "#..#.#..#....#.#..#.#..#.#..#....#.#..#.",
      "#..#.###....#..#....#..#.#..#...#..#..#.",
      "###..#..#..#...#.##.###..####..#...####.",
      "#....#..#.#....#..#.#.#..#..#.#....#..#.",
      "#....###..####..###.#..#.#..#.####.#..#."
    ]
  """
  @spec part2(String.t()) :: [String.t()]
  def part2(input) do
    input
    |> prepare_input()
    |> Enum.reduce([1], fn instruction, register_history ->
      register_history ++ process(instruction, List.last(register_history, 1))
    end)
    |> Enum.with_index()
    |> Enum.take(240)
    |> Enum.map(fn {reg, cycle} ->
      if Integer.mod(cycle, 40) in (reg - 1)..(reg + 1), do: "#", else: "."
    end)
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join/1)
  end

  @spec prepare_input(String.t()) :: any()
  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&(String.trim(&1) |> String.split(" ", trim: true)))
  end

  @spec process([String.t()], integer()) :: [integer()]
  defp process(["noop"], register), do: [register]
  defp process(["addx", num], register), do: [register, register + String.to_integer(num)]
end
