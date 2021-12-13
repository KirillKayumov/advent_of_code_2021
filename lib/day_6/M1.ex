# 345387
defmodule Day6.M1 do
  def run_day(fishes, 80), do: length(fishes)

  def run_day(fishes, day) do
    IO.puts(day)

    fishes
    |> Enum.reduce([], fn fish, acc ->
      case fish do
        0 -> [6, 8 | acc]
        fish -> [fish - 1 | acc]
      end
    end)
    |> run_day(day + 1)
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_6.txt")

    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> run_day(0)
  end
end
