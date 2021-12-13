# 345387
defmodule Day6.M2 do
  def run_day(fishes, 256), do: fishes |> Map.values() |> Enum.sum()

  def run_day(fishes, day) do
    acc = for i <- 0..8, into: %{}, do: {i, 0}

    fishes
    |> Enum.reduce(acc, fn {fish_index, fish_count}, acc ->
      case fish_count do
        0 ->
          acc

        _ ->
          case fish_index do
            0 ->
              acc
              |> Map.update!(6, &(&1 + fish_count))
              |> Map.update!(8, &(&1 + fish_count))

            _ ->
              acc
              |> Map.update!(fish_index - 1, &(&1 + fish_count))
          end
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
    |> then(&Enum.frequencies/1)
    |> run_day(0)
  end
end
