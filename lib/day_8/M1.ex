# 352
defmodule Day8.M1 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_8.txt")

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " | "))
    |> Enum.map(fn [_a, b] -> String.split(b, " ") end)
    |> Enum.reduce(0, fn digits, acc ->
      value =
        digits
        |> Enum.filter(&(String.length(&1) in [2, 3, 4, 7]))
        |> length()

      acc + value
    end)
  end
end
