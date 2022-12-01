
defmodule Advent2022 do
  @moduledoc false

  @spec load_data(integer()) :: binary
  def load_data(day), do: "data/day#{day}.txt" |> File.read!()
end
