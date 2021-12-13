defmodule Day1.M1 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_1_1.txt")

    input =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index(&{&1, &2})

    Enum.reduce(input, 0, fn {elem, index}, acc ->
      case index do
        0 ->
          acc

        _ ->
          previous_elem =
            input
            |> Enum.at(index - 1)
            |> elem(0)

          cond do
            elem > previous_elem -> acc + 1
            true -> acc
          end
      end
    end)
  end
end
