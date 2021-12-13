defmodule Day3.M2 do
  def step(_col, data, _comparator) when length(data) == 1, do: hd(data)

  def step(col, data, comparator) do
    bits =
      for row <- 0..(length(data) - 1), into: [] do
        data
        |> Enum.at(row)
        |> Enum.at(col)
      end

    zeros_count = Enum.count(bits, &(&1 == "0"))
    ones_count = Enum.count(bits, &(&1 == "1"))
    compared_bit = comparator.(zeros_count, ones_count)

    new_data = Enum.filter(data, fn bits -> Enum.at(bits, col) == compared_bit end)

    step(col + 1, new_data, comparator)
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_3_1.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.codepoints/1)

    oxygen =
      step(0, data, fn
        zeros_count, ones_count when zeros_count > ones_count -> "0"
        _, _ -> "1"
      end)
      |> Enum.join("")
      |> String.to_integer(2)

    co2 =
      step(0, data, fn
        zeros_count, ones_count when zeros_count <= ones_count -> "0"
        _, _ -> "1"
      end)
      |> Enum.join("")
      |> String.to_integer(2)

    oxygen * co2
  end
end
