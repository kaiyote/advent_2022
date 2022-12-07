defmodule Advent2022.Day7 do
  @moduledoc false

  @type file :: {integer(), String.t()}
  @type dir_ref :: String.t()
  @type tree :: %{String.t() => [file() | dir_ref()]}

  @doc ~S"""
    iex> part1("$ cd /
    ...>        $ ls
    ...>        dir a
    ...>        14848514 b.txt
    ...>        8504156 c.dat
    ...>        dir d
    ...>        $ cd a
    ...>        $ ls
    ...>        dir e
    ...>        29116 f
    ...>        2557 g
    ...>        62596 h.lst
    ...>        $ cd e
    ...>        $ ls
    ...>        584 i
    ...>        $ cd ..
    ...>        $ cd ..
    ...>        $ cd d
    ...>        $ ls
    ...>        4060174 j
    ...>        8033020 d.log
    ...>        5626152 d.ext
    ...>        7214296 k")
    95437

    iex> Advent2022.load_data(7) |> part1()
    1077191
  """
  @spec part1(String.t()) :: integer()
  def part1(input) do
    tree =
      input
      |> prepare_input()
      |> build_tree()
      |> elem(0)

    tree
    |> Map.keys()
    |> Enum.map(&{&1, get_size(&1, tree)})
    |> Enum.filter(fn {_, s} -> s <= 100_000 end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  @doc ~S"""
    iex> part2("$ cd /
    ...>        $ ls
    ...>        dir a
    ...>        14848514 b.txt
    ...>        8504156 c.dat
    ...>        dir d
    ...>        $ cd a
    ...>        $ ls
    ...>        dir e
    ...>        29116 f
    ...>        2557 g
    ...>        62596 h.lst
    ...>        $ cd e
    ...>        $ ls
    ...>        584 i
    ...>        $ cd ..
    ...>        $ cd ..
    ...>        $ cd d
    ...>        $ ls
    ...>        4060174 j
    ...>        8033020 d.log
    ...>        5626152 d.ext
    ...>        7214296 k")
    24933642

    iex> Advent2022.load_data(7) |> part2()
    5649896
  """
  @spec part2(String.t()) :: integer()
  def part2(input) do
    tree =
      input
      |> prepare_input()
      |> build_tree()
      |> elem(0)

    unused = 70_000_000 - get_size("/", tree)
    min_delete = 30_000_000 - unused

    tree
    |> Map.keys()
    |> Enum.map(&{&1, get_size(&1, tree)})
    |> Enum.filter(fn {_, s} -> s >= min_delete end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.min()
  end

  @spec prepare_input(String.t()) :: any()
  defp prepare_input(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Enum.map(&(&1 |> String.trim() |> String.split(" ", trim: true)))
  end

  @spec build_tree([[String.t()]]) :: {tree(), [String.t()]}
  defp build_tree(console_output) do
    console_output
    |> Enum.reduce({%{}, []}, &process_line/2)
  end

  @spec process_line([String.t()], {tree(), [String.t()]}) :: {tree(), [String.t()]}
  defp process_line(["$", "cd", dir], {tree, dir_stack}) do
    dir_stack =
      case dir do
        ".." -> Enum.drop(dir_stack, 1)
        "/" -> []
        name -> [name] ++ dir_stack
      end

    {tree, dir_stack}
  end

  defp process_line(["$", "ls"], {tree, dir_stack}) do
    {tree |> Map.put_new(canonical_path(dir_stack), []), dir_stack}
  end

  defp process_line(["dir", dir], {tree, dir_stack}) do
    {tree |> Map.update!(canonical_path(dir_stack), fn v -> Enum.uniq(v ++ [dir]) end), dir_stack}
  end

  defp process_line([size, file], {tree, dir_stack}) do
    {tree
     |> Map.update!(canonical_path(dir_stack), fn v ->
       Enum.uniq(v ++ [{String.to_integer(size), file}])
     end), dir_stack}
  end

  @spec get_size(String.t(), tree()) :: integer()
  defp get_size(dir, tree) do
    tree
    |> Map.get(dir)
    |> Enum.reduce(0, fn
      {size, _}, acc -> acc + size
      sub_dir, acc -> acc + get_size(canonical_path([sub_dir, dir]), tree)
    end)
  end

  @spec canonical_path([String.t()]) :: String.t()
  defp canonical_path([]), do: "/"

  defp canonical_path(dir_stack),
    do: dir_stack |> Enum.reverse() |> Enum.drop_while(fn p -> p == "/" end) |> Enum.join("/")
end
