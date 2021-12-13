defmodule Day2.M1 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_2_1.txt")

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [command, amount] -> [command, String.to_integer(amount)] end)
    |> Enum.reduce(%{x: 0, depth: 0}, fn [command, amount], acc ->
      case command do
        "forward" -> Map.update!(acc, :x, &(&1 + amount))
        "down" -> Map.update!(acc, :depth, &(&1 + amount))
        "up" -> Map.update!(acc, :depth, &(&1 - amount))
      end
    end)
    |> then(&(&1.x * &1.depth))
  end
end
