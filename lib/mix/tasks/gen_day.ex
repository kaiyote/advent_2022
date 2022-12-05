defmodule Mix.Tasks.GenDay do
  @moduledoc false
  use Mix.Task

  def run([day_num]) do
    app_dir = File.cwd!()
    app_name = app_dir |> Path.basename()
    file_name = "day#{day_num}"

    module_name =
      "#{String.replace(String.capitalize(app_name), "_", "")}.#{String.capitalize(file_name)}"

    code_path = Path.join([app_dir, "lib", app_name, "#{file_name}.ex"])
    test_path = Path.join([app_dir, "test", app_name, "#{file_name}_test.exs"])
    data_path = Path.join([app_dir, "data", "#{file_name}.txt"])

    File.write(
      code_path,
      """
      defmodule #{module_name} do
        @moduledoc false

        @doc ~S\"\"\"
          iex> part1("")
          0
        \"\"\"
        @spec part1(String.t()) :: integer()
        def part1(input) do
          0
        end

        @doc ~S\"\"\"
          iex> part2("")
          0
        \"\"\"
        @spec part2(String.t()) :: integer()
        def part2(input) do
          0
        end

        @spec prepare_input(String.t()) :: any()
        defp prepare_input(input) do
          input
          |> String.trim()
        end
      end
      """,
      [:write]
    )

    File.write(
      test_path,
      """
      defmodule #{module_name}Test do
        @moduledoc false
        use ExUnit.Case, async: true

        doctest #{module_name}, import: true
      end
      """,
      [:write]
    )

    File.write(data_path, "", [:write])
  end
end
