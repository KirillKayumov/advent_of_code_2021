defmodule Day14.M1 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_14.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n\n")

    [template, pairs] = data

    pairs =
      for pair <- String.split(pairs, "\n"), into: %{} do
        [from, to] = String.split(pair, " -> ")

        {from, to}
      end

    0..9
    |> Enum.reduce(template, fn _, template ->
      0..(String.length(template) - 1)
      |> Enum.reduce("", fn index, acc ->
        value_1 = String.at(template, index)
        value_2 = String.at(template, index + 1) || ""
        key = value_1 <> value_2

        cond do
          Map.has_key?(pairs, key) -> acc <> value_1 <> pairs[key]
          true -> acc <> value_1
        end
      end)
    end)
    |> then(fn template ->
      template
      |> String.codepoints()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.min_max()
      |> then(fn {min, max} -> max - min end)
    end)
  end
end
