defmodule Day2.M2 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_2_1.txt")

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [command, amount] -> [command, String.to_integer(amount)] end)
    |> Enum.reduce(%{x: 0, depth: 0, aim: 0}, fn [command, amount], acc ->
      case command do
        "forward" ->
          acc
          |> Map.update!(:x, &(&1 + amount))
          |> Map.update!(:depth, &(&1 + acc.aim * amount))

        "down" ->
          Map.update!(acc, :aim, &(&1 + amount))

        "up" ->
          Map.update!(acc, :aim, &(&1 - amount))
      end
    end)
    |> then(&(&1.x * &1.depth))
  end
end
