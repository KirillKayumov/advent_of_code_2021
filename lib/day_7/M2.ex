# 98905973
defmodule Day7.M2 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_7.txt")

    data =
      input
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {min, max} = Enum.min_max(data)

    for i <- min..max do
      Enum.reduce(data, 0, fn position, acc ->
        acc + Enum.sum(0..abs(position - i))
      end)
    end
    |> Enum.min()
  end
end
