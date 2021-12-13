# 5092
defmodule Day5.M1 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_5_test.txt")

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, fn row, acc ->
      [from, to] = String.split(row, " -> ")

      [from_x, from_y] = String.split(from, ",") |> Enum.map(&String.to_integer/1)
      [to_x, to_y] = String.split(to, ",") |> Enum.map(&String.to_integer/1)

      cond do
        from_x == to_x || from_y == to_y ->
          for(x <- from_x..to_x, y <- from_y..to_y, do: {x, y})
          |> Enum.reduce(acc, fn coords, acc ->
            Map.update(acc, coords, 1, &(&1 + 1))
          end)

        true ->
          acc
      end
    end)
    |> Enum.reduce(0, fn
      {_, value}, acc when value >= 2 -> acc + 1
      _, acc -> acc
    end)
  end
end
