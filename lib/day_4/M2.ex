defmodule Day4.M2 do
  def won_bingo?(bingo) do
    won_bingo_row?(bingo) || won_bingo_column?(bingo)
  end

  def won_bingo_column?(bingo) do
    Enum.any?(0..4, fn column ->
      Enum.all?(0..4, fn row -> bingo |> Enum.at(row) |> Enum.at(column) end)
    end)
  end

  def won_bingo_row?(bingo) do
    Enum.any?(bingo, fn row -> Enum.all?(row, fn col -> col end) end)
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_4.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n\n")

    numbers =
      data
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    matrices =
      data
      |> Enum.slice(1, length(data))
      |> Enum.map(fn matrix ->
        matrix
        |> String.split("\n")
        |> Enum.map(fn row ->
          [
            row |> String.slice(0, 2) |> String.trim() |> String.to_integer(),
            row |> String.slice(3, 2) |> String.trim() |> String.to_integer(),
            row |> String.slice(6, 2) |> String.trim() |> String.to_integer(),
            row |> String.slice(9, 2) |> String.trim() |> String.to_integer(),
            row |> String.slice(12, 2) |> String.trim() |> String.to_integer()
          ]
        end)
      end)

    bingos =
      matrices
      |> Enum.map(fn matrix ->
        matrix
        |> Enum.map(fn row ->
          row
          |> Enum.map(fn _ -> false end)
        end)
      end)

    numbers
    |> Enum.reduce(%{bingos: bingos, last_won_bingo_index: nil, last_won_number: nil}, fn
      _number, %{last_won_number: last_won_number} = acc when not is_nil(last_won_number) ->
        acc

      number, acc ->
        new_bingos =
          acc.bingos
          |> Enum.with_index(fn bingo, bingo_index ->
            bingo
            |> Enum.with_index(fn row, row_index ->
              row
              |> Enum.with_index(fn column, column_index ->
                column || matrices |> Enum.at(bingo_index) |> Enum.at(row_index) |> Enum.at(column_index) == number
              end)
            end)
          end)

        won_bingos_count = Enum.count(new_bingos, &won_bingo?/1)
        total_bingos_count = length(acc.bingos)

        acc =
          cond do
            won_bingos_count == total_bingos_count ->
              %{acc | last_won_number: number}

            won_bingos_count == total_bingos_count - 1 ->
              last_won_bingo_index = Enum.find_index(new_bingos, fn bingo -> !won_bingo?(bingo) end)
              %{acc | last_won_bingo_index: last_won_bingo_index}

            true ->
              acc
          end

        %{acc | bingos: new_bingos}
    end)
    |> then(fn result ->
      matrix = Enum.at(matrices, result.last_won_bingo_index)
      bingo = Enum.at(result.bingos, result.last_won_bingo_index)

      mult =
        bingo
        |> Enum.with_index()
        |> Enum.reduce(0, fn {row, row_index}, acc ->
          result =
            row
            |> Enum.with_index()
            |> Enum.reduce(0, fn {column, column_index}, acc ->
              case column do
                false -> acc + (matrix |> Enum.at(row_index) |> Enum.at(column_index))
                true -> acc
              end
            end)

          acc + result
        end)

      mult * result.last_won_number
    end)
  end
end
