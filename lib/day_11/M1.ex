defmodule Day11.M1 do
  def apply_flash(data, row_index, column_index, highlighted_octopuses) do
    Map.update(data, {row_index, column_index}, 0, fn value ->
      cond do
        Map.get(highlighted_octopuses, {row_index, column_index}) -> value
        true -> value + 1
      end
    end)
  end

  def step_done?(data) do
    values = for row <- 0..9, column <- 0..9, do: Map.get(data, {row, column})

    Enum.all?(values, &(&1 <= 9))
  end

  def run_step(acc) do
    acc =
      0..9
      |> Enum.reduce(acc, fn row_index, acc ->
        0..9
        |> Enum.reduce(acc, fn column_index, acc ->
          energy = Map.get(acc.data, {row_index, column_index})

          cond do
            energy >= 10 ->
              new_data =
                acc.data
                |> Map.update!({row_index, column_index}, fn _ -> 0 end)
                |> apply_flash(row_index - 1, column_index - 1, acc.highlighted_octopuses)
                |> apply_flash(row_index - 1, column_index, acc.highlighted_octopuses)
                |> apply_flash(row_index - 1, column_index + 1, acc.highlighted_octopuses)
                |> apply_flash(row_index, column_index - 1, acc.highlighted_octopuses)
                |> apply_flash(row_index, column_index + 1, acc.highlighted_octopuses)
                |> apply_flash(row_index + 1, column_index - 1, acc.highlighted_octopuses)
                |> apply_flash(row_index + 1, column_index, acc.highlighted_octopuses)
                |> apply_flash(row_index + 1, column_index + 1, acc.highlighted_octopuses)

              %{
                acc
                | data: new_data,
                  flashes: acc.flashes + 1,
                  highlighted_octopuses: Map.put(acc.highlighted_octopuses, {row_index, column_index}, true)
              }

            true ->
              acc
          end
        end)
      end)

    cond do
      step_done?(acc.data) ->
        acc

      true ->
        run_step(acc)
    end
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_11.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn row -> row |> String.codepoints() |> Enum.map(&String.to_integer/1) end)

    data = for row <- 0..9, column <- 0..9, into: %{}, do: {{row, column}, data |> Enum.at(row) |> Enum.at(column)}

    0..99
    |> Enum.reduce(%{data: data, flashes: 0, highlighted_octopuses: %{}}, fn _, acc ->
      new_data = for {k, v} <- acc.data, into: %{}, do: {k, v + 1}
      acc = %{acc | data: new_data, highlighted_octopuses: %{}}

      run_step(acc)
    end)
    |> then(fn %{data: data, flashes: flashes} ->
      IO.inspect(flashes)

      for row <- 0..9 do
        for column <- 0..9 do
          Map.get(data, {row, column})
        end
      end
    end)
  end
end
