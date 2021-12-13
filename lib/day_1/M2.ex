defmodule Day1.M2 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_1_1.txt")
    # {:ok, input} = File.read("lib/inputs/day_1_test.txt")

    input =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index(&{&1, &2})

    input_3 =
      Enum.reduce(input, [], fn {elem, index}, acc ->
        case index do
          0 ->
            acc

          1 ->
            acc

          _ ->
            elem_1 = input |> Enum.at(index - 2) |> elem(0)
            elem_2 = input |> Enum.at(index - 1) |> elem(0)

            acc ++ [elem + elem_1 + elem_2]
        end
      end)

    input_3 = input_3 |> Enum.with_index(&{&1, &2})

    Enum.reduce(input_3, 0, fn {elem, index}, acc ->
      case index do
        0 ->
          acc

        _ ->
          previous_elem = input_3 |> Enum.at(index - 1) |> elem(0)

          cond do
            elem > previous_elem -> acc + 1
            true -> acc
          end
      end
    end)
  end
end
