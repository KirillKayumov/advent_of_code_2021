defmodule Day9.M2 do
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

  def valid_cell?(value, x, y, data, visited_data) do
    value < get_at(data, x, y) && get_at(data, x, y) < 9 && !get_at(visited_data, x, y)
  end

  def find_basin_size(data, x, y, visited_data) do
    value = get_at(data, x, y)

    visited_data = List.replace_at(visited_data, x, Enum.at(visited_data, x) |> List.replace_at(y, true))

    {up, visited_data} =
      if valid_cell?(value, x - 1, y, data, visited_data), do: find_basin_size(data, x - 1, y, visited_data), else: {0, visited_data}

    {down, visited_data} =
      if valid_cell?(value, x + 1, y, data, visited_data), do: find_basin_size(data, x + 1, y, visited_data), else: {0, visited_data}

    {left, visited_data} =
      if valid_cell?(value, x, y - 1, data, visited_data), do: find_basin_size(data, x, y - 1, visited_data), else: {0, visited_data}

    {right, visited_data} =
      if valid_cell?(value, x, y + 1, data, visited_data), do: find_basin_size(data, x, y + 1, visited_data), else: {0, visited_data}

    {1 + left + right + up + down, visited_data}
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_9.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.codepoints/1)
      |> Enum.map(fn digits -> Enum.map(digits, &String.to_integer/1) end)

    visited_data =
      Enum.map(data, fn row ->
        Enum.map(row, fn _ -> false end)
      end)

    for(
      x <- 0..(length(data) - 1),
      y <- 0..(length(Enum.at(data, 0)) - 1),
      do: {x, y}
    )
    |> Enum.reduce([], fn {x, y}, acc ->
      value = get_at(data, x, y)

      cond do
        value < get_at(data, x - 1, y) && value < get_at(data, x + 1, y) &&
          value < get_at(data, x, y - 1) && value < get_at(data, x, y + 1) ->
          {basin_size, _} = find_basin_size(data, x, y, visited_data)
          [basin_size | acc]

        true ->
          acc
      end
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(1, &(&1 * &2))
  end
end
