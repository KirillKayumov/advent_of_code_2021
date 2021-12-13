defmodule Day3.M1 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_3_1.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.codepoints/1)

    data =
      for col <- 0..11, into: [] do
        for row <- 0..(length(data) - 1), into: [] do
          data
          |> Enum.at(row)
          |> Enum.at(col)
        end
      end
      |> Enum.map(fn bits ->
        zeros_count = Enum.count(bits, &(&1 == "0"))
        ones_count = Enum.count(bits, &(&1 == "1"))

        %{
          min: if(zeros_count < ones_count, do: "0", else: "1"),
          max: if(zeros_count > ones_count, do: "0", else: "1")
        }
      end)

    gamma = for(%{max: n} <- data, into: "", do: n) |> String.to_integer(2)
    epsilon = for(%{min: n} <- data, into: "", do: n) |> String.to_integer(2)

    gamma * epsilon
  end
end
