# 480
defmodule Day9.M1 do
  def get_at(_data, x, _y) when x < 0, do: 10
  def get_at(_data, _x, y) when y < 0, do: 10
  def get_at(data, x, _y) when x >= length(data), do: 10

  def get_at(data, x, y) do
    size = length(Enum.at(data, 0))

    case y do
      ^size -> 10
      _ -> data |> Enum.at(x) |> Enum.at(y)
    end
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_9.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.codepoints/1)
      |> Enum.map(fn digits -> Enum.map(digits, &String.to_integer/1) end)

    for(
      x <- 0..(length(data) - 1),
      y <- 0..(length(Enum.at(data, 0)) - 1),
      do: {x, y}
    )
    |> Enum.reduce(0, fn {x, y}, acc ->
      value = get_at(data, x, y)

      cond do
        value < get_at(data, x - 1, y) && value < get_at(data, x + 1, y) &&
          value < get_at(data, x, y - 1) && value < get_at(data, x, y + 1) ->
          acc + value + 1

        true ->
          acc
      end
    end)
  end
end
